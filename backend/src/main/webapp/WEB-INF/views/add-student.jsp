<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Add Student - SMS</title>
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
    <h3 class="page-title"><i class="bi bi-person-plus-fill me-2"></i>Add New Student</h3>
    <div class="form-card">
      <form id="addForm">
        <h5 class="section-title">Personal Details</h5>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label">Student Name *</label>
            <input class="form-control" name="studentName" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">Roll Number *</label>
            <input class="form-control" name="rollNumber" required>
          </div>
          <div class="col-md-4">
            <label class="form-label">Department *</label>
            <select class="form-select" name="department" required>
              <option value="">-- Select --</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Admission Type *</label>
            <select class="form-select" name="admissionType" id="admissionType" required>
              <option value="">-- Select --</option>
              <option>Regular</option>
              <option>Lateral Entry</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Academic Year *</label>
            <select class="form-select" name="academicYear" id="academicYear" required>
              <option value="">-- Select --</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Gender *</label>
            <select class="form-select" name="gender" required>
              <option value="">-- Select --</option>
              <option>Male</option><option>Female</option><option>Other</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Date of Birth</label>
            <input type="date" class="form-control" name="dateOfBirth">
          </div>
          <div class="col-md-4">
            <label class="form-label">Mobile Number</label>
            <input class="form-control" name="mobileNumber" maxlength="15">
          </div>
          <div class="col-md-12">
            <label class="form-label">Email Address</label>
            <input type="email" class="form-control" name="email">
          </div>
        </div>

        <h5 class="section-title">Prior Academic Details</h5>
        <div class="row g-3">
          <div class="col-md-4" id="sscGroup">
            <label class="form-label">SSC Percentage</label>
            <input type="number" step="0.01" class="form-control" name="sscPercentage">
          </div>
          <div class="col-md-4" id="interGroup">
            <label class="form-label">Intermediate Percentage</label>
            <input type="number" step="0.01" class="form-control" name="interPercentage">
          </div>
          <div class="col-md-4 hidden" id="diplomaGroup">
            <label class="form-label">Diploma Percentage</label>
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
          <button type="submit" class="btn btn-brand"><i class="bi bi-save me-1"></i> Save Student</button>
          <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">Cancel</a>
        </div>
        <div id="msg" class="alert-inline hidden"></div>
      </form>
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

    const form = document.getElementById("addForm");
    const msg = document.getElementById("msg");
    const admissionType = document.getElementById("admissionType");
    const academicYear = document.getElementById("academicYear");
    const sscGroup = document.getElementById("sscGroup");
    const interGroup = document.getElementById("interGroup");
    const diplomaGroup = document.getElementById("diplomaGroup");
    const semGrid = document.getElementById("semGrid");
    const deptSelect = form.querySelector('[name="department"]');

    DEPARTMENTS.forEach(d => {
      const option = document.createElement("option");
      option.value = d;
      option.textContent = d;
      deptSelect.appendChild(option);
    });

    for (let i = 1; i <= 8; i++) {
      const col = document.createElement("div");
      col.className = "col-md-3";
      col.id = `semCol${i}`;
      col.innerHTML = `
        <label class="form-label">Semester ${i} SGPA</label>
        <input type="number" step="0.01" class="form-control" name="sem${i}Sgpa">
      `;
      semGrid.appendChild(col);
    }

    function updateFieldsForRules() {
      const type = admissionType.value;
      academicYear.innerHTML = '<option value="">-- Select --</option>';
      if (type === "Regular") {
        academicYear.innerHTML += '<option>1st Year</option>';
        sscGroup.classList.remove("hidden");
        interGroup.classList.remove("hidden");
        diplomaGroup.classList.add("hidden");
        for (let i = 1; i <= 8; i++) document.getElementById(`semCol${i}`).classList.remove("hidden");
      } else if (type === "Lateral Entry") {
        academicYear.innerHTML += '<option>2nd Year</option>';
        sscGroup.classList.remove("hidden");
        interGroup.classList.add("hidden");
        diplomaGroup.classList.remove("hidden");
        document.getElementById("semCol1").classList.add("hidden");
        document.getElementById("semCol2").classList.add("hidden");
        for (let i = 3; i <= 8; i++) document.getElementById(`semCol${i}`).classList.remove("hidden");
      } else {
        for (let i = 1; i <= 8; i++) document.getElementById(`semCol${i}`).classList.remove("hidden");
      }
    }

    admissionType.addEventListener("change", updateFieldsForRules);

    function formToJson() {
      const fd = new FormData(form);
      const obj = {};
      fd.forEach((v, k) => { obj[k] = v === "" ? null : v; });
      ["sscPercentage","interPercentage","diplomaPercentage","finalCgpa",
       "sem1Sgpa","sem2Sgpa","sem3Sgpa","sem4Sgpa",
       "sem5Sgpa","sem6Sgpa","sem7Sgpa","sem8Sgpa"].forEach(k => {
        if (obj[k] != null) obj[k] = Number(obj[k]);
      });
      return obj;
    }

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      msg.className = "alert-inline hidden";
      const body = formToJson();
      const { ok, data } = await apiFetch("/students", {
        method: "POST",
        body: JSON.stringify(body)
      });
      msg.textContent = (data && data.message) || (ok ? "Saved." : "Failed to save.");
      msg.className = "alert-inline " + (ok ? "success" : "error");
      if (ok) form.reset();
    });
  </script>
</body>
</html>
