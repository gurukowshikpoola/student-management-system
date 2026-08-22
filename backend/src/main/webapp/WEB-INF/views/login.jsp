<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Admin Login - Student Management System</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-icon"><i class="bi bi-mortarboard-fill"></i></div>
      <h2 class="text-center">Admin Login</h2>
      <p class="subtitle text-center">Student Management System</p>

      <form id="loginForm">
        <div class="mb-3">
          <label class="form-label">Admin ID</label>
          <input type="text" id="adminId" class="form-control" placeholder="Enter Admin ID" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Password</label>
          <input type="password" id="password" class="form-control" placeholder="Enter Password" required>
        </div>
        <button type="submit" class="btn btn-brand w-100">
          <i class="bi bi-box-arrow-in-right me-1"></i> Login
        </button>
        <div id="msg" class="alert-inline hidden"></div>
      </form>
    </div>
  </div>

  <script>
    const API_BASE = "${pageContext.request.contextPath}/api";

    async function apiFetch(path, options = {}) {
      const res = await fetch(API_BASE + path, {
        headers: { "Content-Type": "application/json" },
        ...options,
      });
      let data = null;
      try { data = await res.json(); } catch (_) {}
      return { ok: res.ok, status: res.status, data };
    }

    const form = document.getElementById("loginForm");
    const msg = document.getElementById("msg");

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      msg.className = "alert-inline hidden";
      const adminId = document.getElementById("adminId").value.trim();
      const password = document.getElementById("password").value;

      const { ok, data } = await apiFetch("/admin/login", {
        method: "POST",
        body: JSON.stringify({ adminId, password })
      });

      if (ok && data && data.success) {
        sessionStorage.setItem("sms_admin", "true");
        window.location.href = "${pageContext.request.contextPath}/dashboard";
      } else {
        msg.textContent = (data && data.message) || "Invalid Admin ID or Password.";
        msg.className = "alert-inline error";
      }
    });
  </script>
</body>
</html>
