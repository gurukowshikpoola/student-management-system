<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin Dashboard - SMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
  <nav class="app-navbar">
    <div class="brand"><i class="bi bi-mortarboard-fill"></i> Student Management System</div>
    <button onclick="logout()"><i class="bi bi-box-arrow-right me-1"></i> Logout</button>
  </nav>

  <div class="page">
    <h3 class="page-title">Admin Dashboard</h3>
    <p class="text-muted mb-4">Welcome, Admin. Choose an operation to continue.</p>

    <div class="dash-grid">
      <a class="dash-card c1" href="${pageContext.request.contextPath}/students/add">
        <div class="icon"><i class="bi bi-person-plus-fill"></i></div>
        <h5>Add Student</h5>
        <p>Register a new student</p>
      </a>
      <a class="dash-card c2" href="${pageContext.request.contextPath}/students/view">
        <div class="icon"><i class="bi bi-people-fill"></i></div>
        <h5>View Students</h5>
        <p>Browse by department</p>
      </a>
      <a class="dash-card c3" href="${pageContext.request.contextPath}/students/update">
        <div class="icon"><i class="bi bi-pencil-square"></i></div>
        <h5>Update Student</h5>
        <p>Edit student details</p>
      </a>
      <a class="dash-card c4" href="${pageContext.request.contextPath}/students/delete">
        <div class="icon"><i class="bi bi-trash-fill"></i></div>
        <h5>Delete Student</h5>
        <p>Remove a student record</p>
      </a>
      <a class="dash-card c5" href="#" onclick="logout(); return false;">
        <div class="icon"><i class="bi bi-box-arrow-right"></i></div>
        <h5>Logout</h5>
        <p>End your admin session</p>
      </a>
    </div>
  </div>

  <script>
    function logout() {
      sessionStorage.removeItem("sms_admin");
      window.location.href = "${pageContext.request.contextPath}/login";
    }

    if (sessionStorage.getItem("sms_admin") !== "true") {
      window.location.href = "${pageContext.request.contextPath}/login";
    }
  </script>
</body>
</html>
