<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Update Student - SMS</title>
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
    <h3 class="page-title"><i class="bi bi-pencil-square me-2"></i>Update Student</h3>

    <div class="form-card mb-3">
      <div class="row g-3 align-items-end">
        <div class="col-md-6">
          <label class="form-label">Enter Roll Number</label>
          <input id="rollInput" class="form-control" placeholder="e.g. 22CSE001">
        </div>
        <div class="col-md-3">
          <button id="fetchBtn" class="btn btn-brand w-100"><i class="bi bi-search me-1"></i> Fetch</button>
        </div>
      </div>
      <div id="fetchMsg" class="alert-inline hidden"></div>
    </div>

    <div id="editCard" class="form-card hidden">
      <form id="updateForm">
        <h5 class="section-title">Personal Details (Roll No & Department locked)</h5>
        <div class="row g-3">
          <div class="col-md-4">
            <label class="form-label">Roll Number</label>
            <input class="form-control" name="rollNumber" disabled>
          </div>
          <div class="col-md-4">
            <label class="form-label">Department</label>
            <input class="form-control" name="department" disabled>
          </div>
          <div class="col-md-4">
            <label class="form-label">Student Name</label>
            <input class="form-control" name="studentName" required>
          </div>
          <div class="col-md-4">
            <label class="form-label">Admission Type</label>
            <select class="form-select" name="admissionType" required>
              <option>Regular</option><option>Lateral Entry</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Academic Year</label>
            <select class="form-select" name="academicYear" required>
              <option>1st Year</option><option>2nd Year</option>
              <option>3rd Year</option><option>4th Year</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Gender</label>
            <select class="form-select" name="gender">
              <option>Male</option><option>Female</option><option>Other</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Date of Birth</label>
            <input type="date" class="form-control" name="dateOfBirth">
          </div>
          <div class="col-md-4">
            <label class="form-label">Mobile Number</label>
            <input class="form-control" name="mobileNumber">
          </div>
          <div class="col-md-4">
            <label class="form-label">Email</label>
            <input type="email" class="form-control" name="email">
          </div>
        </div>

        <h5 class="section-title">Prior Academic Details</h5>
        <div class="row g-3">
          <div class="col-md-4">
            <label class="form-label">SSC %</label>
            <input type="number" step="0.01" class="form-control" name="sscPercentage">
          </div>
          <div class="col-md-4">
            <label class="form-label">Intermediate %</label>
            <input type="number" step="0.01" class="form-control" name="interPercentage">
          </div>
          <div class="col-md-4">
            <label class="form-label">Diploma %</label>
            <input type="number" step="0.01" class="form-control" name="diplomaPercentage">
          </div>
        </div>

        <h5 class="section-title">Semester SGPAs</h5>
        <div class="row g-3" id="semGrid"></div>

        <div class="row g-3 mt-1">
          <div class="col-md-4">
            <label class="form-label">Final CGPA</label>
            <input type="number" step="0.01" class="form-control" name="finalCgpa">
          </div>
        </div>

        <div class="mt-4 d-flex gap-2">
          <button type="submit" class="btn btn-brand"><i class="bi bi-check2-circle me-1"></i> Update</button>
          <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">Cancel</a>
        </div>
        <div id="msg" class="alert-inline hidden"></div>
      </form>
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

    const rollInput = document.getElementById("rollInput");
    const fetchBtn = document.getElementById("fetchBtn");
    const fetchMsg = document.getElementById("fetchMsg");
    const editCard = document.getElementById("editCard");
    const form = document.getElementById("updateForm");
    const msg = document.getElementById("msg");
    const semGrid = document.getElementById("semGrid");

    for (let i = 1; i <= 8; i++) {
      const col = document.createElement("div");
      col.className = "col-md-3";
      col.innerHTML = `
        <label class="form-label">Semester ${i} SGPA</label>
        <input type="number" step="0.01" class="form-control" name="sem${i}Sgpa">
      `;
      semGrid.appendChild(col);
    }

    let currentRoll = null;

    fetchBtn.addEventListener("click", async () => {
      fetchMsg.className = "alert-inline hidden";
      editCard.classList.add("hidden");
      const roll = rollInput.value.trim();
      if (!roll) return;
      const { ok, data } = await apiFetch(`/students/${encodeURIComponent(roll)}`);
      if (!ok) {
        fetchMsg.textContent = (data && data.message) || "Student not found.";
        fetchMsg.className = "alert-inline error";
        return;
      }
      currentRoll = data.rollNumber;
      Object.keys(data).forEach(key => {
        const element = form.querySelector(`[name="${key}"]`);
        if (!element) return;
        element.value = data[key] == null ? "" : data[key];
      });
      editCard.classList.remove("hidden");
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      msg.className = "alert-inline hidden";
      const fd = new FormData(form);
      const body = {};
      fd.forEach((v, k) => body[k] = v === "" ? null : v);
      ["sscPercentage","interPercentage","diplomaPercentage","finalCgpa",
       "sem1Sgpa","sem2Sgpa","sem3Sgpa","sem4Sgpa",
       "sem5Sgpa","sem6Sgpa","sem7Sgpa","sem8Sgpa"].forEach(k => {
        if (body[k] != null) body[k] = Number(body[k]);
      });
      const { ok, data } = await apiFetch(`/students/${encodeURIComponent(currentRoll)}`, {
        method: "PUT",
        body: JSON.stringify(body)
      });
      msg.textContent = (data && data.message) || (ok ? "Updated." : "Update failed.");
      msg.className = "alert-inline " + (ok ? "success" : "error");
    });
  </script>
</body>
</html>
