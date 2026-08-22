<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>View Students - SMS</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
  <nav class="app-navbar">
    <div class="brand"><i class="bi bi-mortarboard-fill"></i> Student Management System</div>
    <div>
      <a href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-house-door me-1"></i> Dashboard</a>
      <button onclick="logout()" class="ms-2"><i class="bi bi-box-arrow-right me-1"></i> Logout</button>
    </div>
  </nav>

  <div class="page">
    <h3 class="page-title"><i class="bi bi-people-fill me-2"></i>View Students</h3>
    <div class="form-card mb-3">
      <div class="row g-3 align-items-end">
        <div class="col-md-4">
          <label class="form-label">Department</label>
          <select id="deptSelect" class="form-select">
            <option value="">-- Select Department --</option>
          </select>
        </div>
        <div class="col-md-5">
          <label class="form-label">Search (Roll Number or Name)</label>
          <input id="searchBox" class="form-control" placeholder="Type to search...">
        </div>
        <div class="col-md-3">
          <button id="loadBtn" class="btn btn-brand w-100"><i class="bi bi-search me-1"></i> Load</button>
        </div>
      </div>
    </div>

    <div class="table-card">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead>
            <tr>
              <th>Roll No</th><th>Name</th><th>Dept</th><th>Year</th>
              <th>Type</th><th>Mobile</th><th>Email</th>
              <th>Sem SGPAs</th><th>CGPA</th>
            </tr>
          </thead>
          <tbody id="rows">
            <tr><td colspan="9" class="text-center text-muted py-4">Select a department or type in search.</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <script>
    const API_BASE = "${pageContext.request.contextPath}/api";
    const DEPARTMENTS = ["CSE","ECE","EEE","MECH","CIVIL","IT","CSD","CSAI","CSM","CSC"];

    function logout() {
      sessionStorage.removeItem("sms_admin");
      window.location.href = "${pageContext.request.contextPath}/login";
    }

    if (sessionStorage.getItem("sms_admin") !== "true") {
      window.location.href = "${pageContext.request.contextPath}/login";
    }

    async function apiFetch(path, options = {}) {
      const res = await fetch(API_BASE + path, {
        headers: { "Content-Type": "application/json" },
        ...options,
      });
      let data = null;
      try { data = await res.json(); } catch (_) {}
      return { ok: res.ok, status: res.status, data };
    }

    const deptSelect = document.getElementById("deptSelect");
    const searchBox = document.getElementById("searchBox");
    const loadBtn = document.getElementById("loadBtn");
    const rows = document.getElementById("rows");

    DEPARTMENTS.forEach(d => {
      const option = document.createElement("option");
      option.value = d;
      option.textContent = d;
      deptSelect.appendChild(option);
    });

    function sgpaSummary(student) {
      const parts = [];
      for (let i = 1; i <= 8; i++) {
        const value = student[`sem${i}Sgpa`];
        if (value != null) parts.push(`S${i}:${value}`);
      }
      return parts.join(", ") || "-";
    }

    function render(list) {
      if (!list || list.length === 0) {
        rows.innerHTML = `<tr><td colspan="9" class="text-center text-muted py-4">No students found.</td></tr>`;
        return;
      }
      rows.innerHTML = list.map(student => `
        <tr>
          <td><strong>${student.rollNumber}</strong></td>
          <td>${student.studentName || ""}</td>
          <td>${student.department || ""}</td>
          <td>${student.academicYear || ""}</td>
          <td>${student.admissionType || ""}</td>
          <td>${student.mobileNumber || ""}</td>
          <td>${student.email || ""}</td>
          <td style="font-size:12px">${sgpaSummary(student)}</td>
          <td><span class="badge bg-primary">${student.finalCgpa ?? "-"}</span></td>
        </tr>
      `).join("");
    }

    async function load() {
      const dept = deptSelect.value;
      const query = searchBox.value.trim();
      if (query) {
        const { data } = await apiFetch(`/students/search?query=${encodeURIComponent(query)}`);
        let list = data || [];
        if (dept) list = list.filter(student => student.department === dept);
        render(list);
      } else if (dept) {
        const { data } = await apiFetch(`/students/department/${encodeURIComponent(dept)}`);
        render(data || []);
      } else {
        rows.innerHTML = `<tr><td colspan="9" class="text-center text-muted py-4">Select a department or type in search.</td></tr>`;
      }
    }

    loadBtn.addEventListener("click", load);
    deptSelect.addEventListener("change", load);
    searchBox.addEventListener("input", () => {
      if (searchBox.value.length === 0 || searchBox.value.length >= 2) load();
    });
  </script>
</body>
</html>
