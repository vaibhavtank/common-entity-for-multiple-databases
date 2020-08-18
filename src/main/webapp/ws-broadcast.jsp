<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
    <head>
        <title>Plain WebSocket Example</title>
        <th:block th:include="fragments/common.html :: headerfiles"></th:block>        
    </head>
    <body>
        <div class="container">
            <div class="py-5 text-center">
                <a href="/"><h2>Basic Web socket</h2></a>
                <p class="lead">Sample of basic WebSocket broadcast - without STOMP & SockJS.</p>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="row mb-3">
                        <div class="input-group">
                            Web socket connection:&nbsp;
                            <div class="btn-group">
                                <button type="button" id="connect" class="btn btn-sm btn-outline-secondary" onclick="connect()">Connect</button>
                            <button type="button" id="disconnect" class="btn btn-sm btn-outline-secondary" onclick="disconnect()" disabled>Disconnect</button>
                            </div>                        
                        </div>
                    </div>
                    <div class="row mb-3">
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
                </div>
            </div>
        </div>

        <footer th:insert="fragments/common.html :: footer"></footer>
        
        <script>
            var ws;
            function setConnected(connected) {
                $("#connect").prop("disabled", connected);
                $("#disconnect").prop("disabled", !connected);
                if (connected) {
                    $("#sendmessage").show();
                } else {
                    $("#sendmessage").hide();
                }
            }

            function connect() {
                /*<![CDATA[*/
                var url = /*[['ws://'+${#httpServletRequest.serverName}+':'+${#httpServletRequest.serverPort}+@{/web-socket}]]*/ 'ws://localhost:8080/web-socket';
                /*]]>*/
                ws = new WebSocket(url);
                ws.onopen = function () {
                    showBroadcastMessage('<div class="alert alert-success">Connected to server</div>');
                };
                ws.onmessage = function (data) {
                    showBroadcastMessage(createTextNode(data.data));
                };
                setConnected(true);
            }

            function disconnect() {
                if (ws != null) {
                    ws.close();
                    showBroadcastMessage('<div class="alert alert-warning">Disconnected from server</div>');
                }
                setConnected(false);
            }            

            function send() {
                ws.send($("#message").val());
                $("#message").val("");
            }

            function createTextNode(msg) {
                return '<div class="alert alert-info">' + msg + '</div>';
            }
            
            function showBroadcastMessage(message) {
                $("#content").html($("#content").html() + message);
            }
        </script>
    </body>
</html>
