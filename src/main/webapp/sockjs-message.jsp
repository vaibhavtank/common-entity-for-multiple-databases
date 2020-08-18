<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
    <head>
        <title>WebSocket With STOMP & SockJS Broadcast Example</title>
        <th:block th:include="fragments/common.html :: headerfiles"></th:block>
    </head>
    <body>
        <div class="container">
            <div class="py-5 text-center">
                <a href="/"><h2>WebSocket</h2></a>
                <p class="lead">WebSocket Chat - with STOMP & SockJS.</p>
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
                    <div class="mb-3" id="users" style="display: none;">
                        <span id="active-users-span"></span>
                        <ul id="active-users" class="list-group list-group-horizontal-sm">
                            <!--/*--> 
                            <!--/*/
                            <div th:with="condition=${#lists.size(activeUsers)}" th:remove="tag">
                                <p th:if="${condition}"><i>No active users found.</i></p>
                                <p th:unless="${condition}" class="text-muted">click on user to begin chat</p>
                            </div>
                            <li th:each="username ${activeUsers}" class="list-group-item">
                                <a class="active-user" href="javascript:void(0)" onclick="setSelectedUser('${username}')">${username}</a>
                            </li>
                            /*/-->
                            <!--*/-->                            
                        </ul>
                    </div>
                    <div id="divSelectedUser" class="mb-3" style="display: none;">
                        <span id="selectedUser" class="badge badge-secondary"></span> Selected
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
                            <button id="clear" class="btn btn-primary" onclick="clearMessages()" style="display: none;">Clear</button>
                        </span>
                    </div>
                    <div id="response"></div>                        
                </div>
            </div>
        </div>

        <footer th:insert="fragments/common.html :: footer"></footer>
        
        <script th:src="@{/webjars/sockjs-client/1.1.2/sockjs.js}" type="text/javascript"></script>
        <script th:src="@{/webjars/stomp-websocket/2.3.3-1/stomp.js}" type="text/javascript"></script>
        <script type="text/javascript">
            var stompClient = null;
            var selectedUser = null;
            var userName = $("#from").val();
            
            function setConnected(connected) {
                $("#from").prop("disabled", connected);
                $("#connect").prop("disabled", connected);
                $("#disconnect").prop("disabled", !connected);
                if (connected) {
                    $("#users").show();
                    $("#sendmessage").show();
                } else {
                    $("#users").hide();
                    $("#sendmessage").hide();
                }
            }
            
            function connect() {
                userName = $("#from").val();
                if (userName == null || userName === "") {
                    alert('Please input a nickname!');
                    return;
                }
                $.post('/rest/user-connect',
                    { username: userName }, 
                    function(remoteAddr, status, xhr) {
                        var socket = new SockJS('/chat');
                        stompClient = Stomp.over(socket);
                        stompClient.connect({username: userName}, function () {
                            stompClient.subscribe('/topic/broadcast', function (output) {
                                showMessage(createTextNode(JSON.parse(output.body)));
                            });
                            
                            stompClient.subscribe('/topic/active', function () {
                                updateUsers(userName);
                            });
                            
                            stompClient.subscribe('/user/queue/messages', function (output) {
                                showMessage(createTextNode(JSON.parse(output.body)));
                            });

                            sendConnection(' connected to server');
                            setConnected(true);
                        }, function (err) {
                            alert('error' + err);
                        });  

                    }).done(function() { 
                        // alert('Request done!'); 
                    }).fail(function(jqxhr, settings, ex) {
                        console.log('failed, ' + ex); 
                    }
                );                              
            }

            function disconnect() {
                if (stompClient != null) {                    
                    $.post('/rest/user-disconnect',
                        { username: userName }, 
                        function() {
                            sendConnection(' disconnected from server'); 
                    
                            stompClient.disconnect(function() {
                                console.log('disconnected...');
                                setConnected(false);
                            });

                        }).done(function() { 
                            // alert('Request done!'); 
                        }).fail(function(jqxhr, settings, ex) {
                            console.log('failed, ' + ex); 
                        }
                    );                                      
                }                
            }
            
            function sendConnection(message) {
                var text = userName + message;
                sendBroadcast({'from': 'server', 'text': text});
                
                // for first time or last time, list active users:
                updateUsers(userName);
            }
            
            function sendBroadcast(json) {
                stompClient.send("/app/broadcast", {}, JSON.stringify(json));
            }
           
            function send() {
                var text = $("#message").val();
                if (selectedUser == null) {
                    alert('Please select a user.');
                    return;
                }
                stompClient.send("/app/chat", {'sender': userName},
                        JSON.stringify({'from': userName, 'text': text, 'recipient': selectedUser}));                
                $("#message").val("");
            }

            function createTextNode(messageObj) {
                var classAlert = 'alert-info';
                var fromTo = messageObj.from;
                var addTo =  fromTo;
                
                if (userName == messageObj.from) {
                    fromTo = messageObj.recipient;
                    addTo =  'to: ' + fromTo;
                }
                
                if (userName != messageObj.from && messageObj.from != "server") {
                    classAlert = "alert-warning";
                }
                
                if (messageObj.from != "server") {
                    addTo = '<a href="javascript:void(0)" onclick="setSelectedUser(\'' + fromTo + '\')">' + addTo + '</a>'
                }
                return '<div class="row alert ' + classAlert + '"><div class="col-md-8">' +
                        messageObj.text +
                        '</div><div class="col-md-4 text-right"><small>[<b>' +
                        addTo +
                        '</b> ' +
                        messageObj.time + 
                        ']</small>' +
                        '</div></div>';
            }
            
            function showMessage(message) {
                $("#content").html($("#content").html() + message);
                $("#clear").show();
            }
            
            function clearMessages() {
                $("#content").html("");
                $("#clear").hide();
            }
            
            function setSelectedUser(username) {
                selectedUser = username;
                $("#selectedUser").html(selectedUser);
                if ($("#selectedUser").html() == "") {
                    $("#divSelectedUser").hide();
                }
                else {
                    $("#divSelectedUser").show();
                }
            }
            
            function updateUsers(userName) {
                // console.log('List of users : ' + userList);               
                var activeUserSpan = $("#active-users-span");
                var activeUserUL = $("#active-users");

                var index;
                activeUserUL.html('');
                
                var url = '/rest/active-users-except/' + userName;
                $.ajax({
                    type: 'GET',
                    url: url,
                    // data: data, 
                    dataType: 'json', // ** ensure you add this line **
                    success: function(userList) {
                        if (userList.length == 0) {
                            activeUserSpan.html('<p><i>No active users found.</i></p>');
                        }
                        else {
                            activeUserSpan.html('<p class="text-muted">click on user to begin chat</p>');
                            
                            for (index = 0; index < userList.length; ++index) {
                                if (userList[index] != userName) {
                                    activeUserUL.html(activeUserUL.html() + createUserNode(userList[index], index));                                    
                                }
                            }
                            /*
                            $.each(userList, function(index, item) {
                                //now you can access properties using dot notation
                            }); 
                            */
                        }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert("error occurred");
                    }
                });
            }
            
            function createUserNode(username, index) {
                return '<li class="list-group-item">' +
                       '<a class="active-user" href="javascript:void(0)" onclick="setSelectedUser(\'' + username + '\')">' + username + '</a>' +
                       '</li>';
            }
        </script>
    </body>
</html>