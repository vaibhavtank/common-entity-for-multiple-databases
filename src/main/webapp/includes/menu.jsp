<%-- <h1>Hello : ${user}</h1>
<div id="tabs">
  <ul>
    <li></li>
    <li></li>
    <li><a onclick="document.forms['logoutForm'].submit()">Logout</a></li>
  </ul>
</div>
 --%>
<h2>Welcome ${pageContext.request.userPrincipal.name}<br> |<a href="${pageContext.request.contextPath}/"><span>Home</span></a>  | <a href="${pageContext.request.contextPath}/chat"><span>Chat</span></a>  |  <a href="${pageContext.request.contextPath}/logout">Logout</a></h2>