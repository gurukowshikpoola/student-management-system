<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Delete Student - SMS</title>
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
    <h3 class="page-title"><i class="bi bi-trash-fill me-2"></i>Delete Student</h3>

    <div class="form-card mb-3">
      <div class="row g-3 align-items-end">
        <div class="col-md-8">
          <label class="form-label">Search by Roll Number or Student Name</label>
          <input id="searchBox" class="form-control" placeholder="Type roll number or name...">
        </div>
        <div class="col-md-4">
          <button id="searchBtn" class="btn btn-brand w-100"><i class="bi bi-search me-1"></i> Search</button>
        </div>
      </div>
    </div>

    <div class="table-card">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead>
            <tr>
              <th>Roll No</th><th>Name</th><th>Dept</th><th>Year</th>
              <th>Type</th><th>Mobile</th><th>Email</th><th>CGPA</th><th></th>
            </tr>
          </thead>
          <tbody id="rows">
            <tr><td colspan="9" class="text-center text-muted py-4">Search to find a student.</td></tr>
          </tbody>
        </table>
      </div>
      <div id="msg" class="alert-inline hidden"></div>
    </div>
  </div>

  <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Confirm Delete</h5>
          <button class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body" id="confirmBody"></div>
        <div class="modal-footer">
          <button class="btn btn-outline-secondary" data-bs-dismiss="modal">No</button>
          <button class="btn btn-danger" id="confirmYes">Yes, Delete</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    const API_BASE = "${pageContext.request.contextPath}/api";

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

    const searchBox = document.getElementById("searchBox");
    const searchBtn = document.getElementById("searchBtn");
    const rows = document.getElementById("rows");
    const msg = document.getElementById("msg");
    const modalEl = document.getElementById("confirmModal");
    const modal = new bootstrap.Modal(modalEl);
    const confirmBody = document.getElementById("confirmBody");
    const confirmYes = document.getElementById("confirmYes");

    let toDelete = null;

    function render(list) {
      if (!list || list.length === 0) {
        rows.innerHTML = `<tr><td colspan="9" class="text-center text-muted py-4">No students matched.</td></tr>`;
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
          <td><span class="badge bg-primary">${student.finalCgpa ?? "-"}</span></td>
          <td>
            <button class="btn btn-sm btn-danger" data-roll="${student.rollNumber}" data-name="${student.studentName || ""}">
              <i class="bi bi-trash"></i>
            </button>
          </td>
        </tr>`).join("");

      rows.querySelectorAll("button[data-roll]").forEach(button => {
        button.addEventListener("click", () => {
          toDelete = button.getAttribute("data-roll");
          confirmBody.innerHTML =
            `Do you want to delete student with Roll Number <strong>${toDelete}</strong>` +
            (button.getAttribute("data-name") ? ` (${button.getAttribute("data-name")})` : "") + `?`;
          modal.show();
        });
      });
    }

    async function doSearch() {
      msg.className = "alert-inline hidden";
      const q = searchBox.value.trim();
      if (!q) return;
      const { data } = await apiFetch(`/students/search?query=${encodeURIComponent(q)}`);
      render(data || []);
    }

    searchBtn.addEventListener("click", doSearch);
    searchBox.addEventListener("keydown", (event) => { if (event.key === "Enter") doSearch(); });

    confirmYes.addEventListener("click", async () => {
      if (!toDelete) return;
      const { ok, data } = await apiFetch(`/students/${encodeURIComponent(toDelete)}`, { method: "DELETE" });
      modal.hide();
      msg.textContent = (data && data.message) || (ok ? "Deleted." : "Delete failed.");
      msg.className = "alert-inline " + (ok ? "success" : "error");
      if (ok) doSearch();
      toDelete = null;
    });
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
