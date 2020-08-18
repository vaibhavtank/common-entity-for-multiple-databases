<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<nav class="navbar" role="navigation">
	<!-- Brand and toggle get grouped for better mobile display -->
	<div class="navbar-header">
		<a class="navbar-brand animated bounceInRight" href="${pageContext.request.userPrincipal.name != null ? 'index.htm' : 'login.htm'}">
			<img src="${pageContext.request.contextPath}/WEB-INF/images/logo.png">
		</a>
	</div>
	<!-- Collect the nav links, forms, and other content for toggling -->
	<div class="collapse navbar-collapse">
		<div class="pull-right ">
			<h3 class="animated bounceInLeft">""</h3>
		</div>
	</div>
	<!-- /.navbar-collapse -->
</nav>
<c:forEach items="${chatData}" var="tsm" varStatus="loop">
	<input type="hidden" value="${tsm.fromUser}" class="chatcss" />
</c:forEach>
<script type="text/javascript">
	$(document).ready(function() {
		if (!$(".submit").is(':visible')) {
			var len = $('.chatcss').length;
			var notidiv = document.createElement('div');
			notidiv.id = "notification";
			notidiv.innerHTML = "Notifications";
			var notispan = document.createElement('span');
			notispan.id = "notification_count";
			notidiv.appendChild(notispan);
			var notia = document.createElement('a');
			notia.id = "notificationLink";
			var valueMsg = len;
			var linkText = document.createTextNode(valueMsg);
			notia.appendChild(linkText);
			notia.title = "my title text";
			notia.href = "#";
			notispan.appendChild(notia);
			var tempdiv = document.getElementById('topbar-main_not');
			tempdiv.appendChild(notidiv);
			var notidivContainer = document.createElement('div');
			notidivContainer.id = "notificationContainer";
			var notiDivTitle = document.createElement('div');
			notiDivTitle.id = "notificationTitle";
			var titleText = document.createTextNode("You have " + len + " unread messages");
			notiDivTitle.appendChild(titleText);
			notidivContainer.appendChild(notiDivTitle);
			var notiDivBody = document.createElement('div');
			notiDivBody.id = "notificationsBody";
			for (var i = 0; i < len; i++) {
				var dispa = document.createElement('a');
				dispa.className = "disp_not";
				var valueMsg = $('.chatcss')[i].value;
				var linkText = document.createTextNode(valueMsg);
				dispa.textAlign = "center";
				dispa.appendChild(linkText);
				dispa.href = "chatnevigation.htm";
				notiDivBody.appendChild(dispa);
			}
			notidivContainer.appendChild(notiDivBody);
			var notiDivFooter = document.createElement('div');
			notiDivFooter.id = "notificationFooter";
			notidivContainer.appendChild(notiDivFooter);
			var notiShowAlla = document.createElement('a');
			notiShowAlla.className = "see_all_cls";
			var valueMsg = "See All";
			var linkText1 = document.createTextNode(valueMsg);
			notiShowAlla.appendChild(linkText1);
			notiShowAlla.title = "my title text";
			notiShowAlla.href = "#";
			notiDivFooter.appendChild(notiShowAlla);
			notidiv.appendChild(notidivContainer);
		}

		$(".btn.btn-nav-toggle.text-primary").click(function(){
			if($("#removeClass.pull-left").is(":visible")) {
				$("#removeClass").removeClass("pull-left");
			} else {
				$("#removeClass").addClass("pull-left");
			}
		});
		
		$("#notification, #removeClass").click(function() {
			$("#notificationContainer").fadeToggle(300);
			//$("#notification_count").fadeToggle(300);
			return false;
		});
		//Document Click hiding the popup 
		$(document).click(function() {
			$("#notificationContainer").hide();
		});
		//Popup on click
		$("#notificationContainer").click(function() {
			return false;
		});
	});
</script>