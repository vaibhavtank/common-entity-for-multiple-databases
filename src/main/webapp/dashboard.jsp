<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Common entity with multiple databases example</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">

<style type="text/css">
tr:first-child {
	font-weignt: bold;
	background-color: #c6c9c4
}
</style>
</head>
<body>
	<div class="container">
		<h2>Home</h2>
		<jsp:include page="includes/menu.jsp" flush="true" />
		<c:if test="${not empty success}">
			<div class="alert alert-success" role="alert">${success}</div>
		</c:if>

		<hr />
		<hr />
		<div class="form-group">
		</div>
		<div class="form-group">
		<table margin="2px" class="table">
			<tr>
				<td>MIRA Exit Date</td>
				<td>Auditor</td>
				<td>Total No Of Transactions</td>
				<td>Error Counts</td>
				<td>Accuracy</td>
			</tr>
			<c:set var="not_total" value="0"/>
			<c:set var="error_total" value="0"/>
			<c:forEach items="${dashboardReport}" var="report">
			<tr>
				<th>${report.miraExitDate} </th>
				<th><a href="<c:url value='/auditorReport?auditor=${report.username}' />">${report.username}</a></th>
				<th>${report.total}</th>
				<th>${report.errorCounts}</th>
				<th>${report.accuracy}</th>
				<c:set var="not_total" value="${not_total + report.total}" />
				<c:set var="error_total" value="${error_total + report.errorCounts}" />
			</tr>
				</c:forEach>
			<tr>
				<td></td>
				<td></td>
				<th>Total: ${not_total}</th>
				<th>Errors: ${error_total}</th>
				<td></td>
			</tr>
		</table>
		</div>
	</div>
</body>
</html>