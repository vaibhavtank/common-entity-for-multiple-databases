<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
    <head>
        <title>WebSocket With STOMP Broadcast Example</title>
        <th:block th:include="fragments/common.html :: headerfiles"></th:block>        
    </head>
    <body>
        <div class="container">
            <div class="py-5 text-center">
                <a href="/"><h2>WebSocket</h2></a>
                <p class="lead">WebSocket Broadcast - with STOMP</p>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <div class="input-group">
                            <input type="text" id="from" class="form-control" placeholder="Choose a nickname"/>
                            <div class="btn-group">
                                <button type="button" id="connect" class="btn btn-sm btn-outline-secondary" onclick="connect()">Connect</button>
                            <button type="button" id="disconnect" class="btn btn-sm btn-outline-secondary" onclick="disconnect()" disabled>Disconnect</button>
                            </div>                        
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="input-group" id="sendmessage" style="display: none;">
                            <input type="text" id="message" class="form-control" placeholder="Message">
                            <div class="input-group-append">
                                <button id="send" class="btn btn-primary" onclick="send()">Send</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div id="content"></div>
                    <div>
                        <span class="float-right">
                            <button id="clear" class="btn btn-primary" onclick="clearBroadcast()" style="display: none;">Clear</button>
                        </span>
                    </div>                    
                </div>
            </div>
        </div>

        <footer th:insert="fragments/common.html :: footer"></footer>
        
        <script th:src="@{/webjars/stomp-websocket/2.3.3-1/stomp.js}" type="text/javascript"></script>
        <script type="text/javascript">
            var stompClient = null;
            var userName = $("#from").val();
            
            function setConnected(connected) {
                $("#from").prop("disabled", connected);
                $("#connect").prop("disabled", connected);
                $("#disconnect").prop("disabled", !connected);
                if (connected) {
                    $("#sendmessage").show();
                } else {
                    $("#sendmessage").hide();
                }
            }
            
            function connect() {
                userName = $("#from").val();
                if (userName == null || userName === "") {
                    alert('Please input a nickname!');
                    return;
                }
                 /*<![CDATA[*/
                var url = /*[['ws://'+${#httpServletRequest.serverName}+':'+${#httpServletRequest.serverPort}+@{/broadcast}]]*/ 'ws://localhost:8080/broadcast';
                /*]]>*/
                stompClient = Stomp.client(url);
                stompClient.connect({}, function () {
                    stompClient.subscribe('/topic/broadcast', function (output) {
                        showBroadcastMessage(createTextNode(JSON.parse(output.body)));
                    });
                    
                    sendConnection(' connected to server');                
                    setConnected(true);
                }, function (err) {
                    alert('error' + err);
                });                
            }

            function disconnect() {
                if (stompClient != null) {
                    sendConnection(' disconnected from server'); 
                    
                    stompClient.disconnect(function() {
                        console.log('disconnected...');
                        setConnected(false);
                    });                    
                }                
            }
            
            function sendConnection(message) {
                var text = userName + message;
                sendBroadcast({'from': 'server', 'text': text});
            }
                    
            function sendBroadcast(json) {
                stompClient.send("/app/broadcast", {}, JSON.stringify(json));
            }
            
            function send() {
                var text = $("#message").val();
                sendBroadcast({'from': userName, 'text': text});
                $("#message").val("");
            }

            function createTextNode(messageObj) {
                return '<div class="row alert alert-info"><div class="col-md-8">' +
                        messageObj.text +
                        '</div><div class="col-md-4 text-right"><small>[<b>' +
                        messageObj.from +
                        '</b> ' +
                        messageObj.time + 
                        ']</small>' +
                        '</div></div>';
            }
            
            function showBroadcastMessage(message) {
                $("#content").html($("#content").html() + message);
                $("#clear").show();
            }
            
            function clearBroadcast() {
                $("#content").html("");
                $("#clear").hide();
            }
        </script>
    </body>
</html>
