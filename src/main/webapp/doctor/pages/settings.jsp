<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<style>
  .tab-btn.active              { background:#0052FF; color:#fff; box-shadow:0 4px 14px rgba(0,82,255,0.25); }
  .tab-btn:not(.active):hover  { background:#EEF3FF; color:#0052FF; }
  .s-tab-panel                 { display:none; }
  .s-tab-panel.active          { display:block; }

  .toggle-checkbox:checked + .toggle-track              { background-color:#0052FF; }
  .toggle-checkbox:checked + .toggle-track .toggle-thumb{ transform:translateX(20px); }
  .toggle-track  { transition:background .2s; }
  .toggle-thumb  { transition:transform .2s; }

  .s-input:focus, .s-select:focus, .s-textarea:focus {
    outline:none; border-color:#0052FF;
    box-shadow:0 0 0 3px rgba(0,82,255,.12);
  }
  @keyframes sUp { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }
  .s-fu   { animation:sUp .35s ease both; }
  .s-fu-1 { animation-delay:.05s; }
  .s-fu-2 { animation-delay:.10s; }
  .s-fu-3 { animation-delay:.15s; }
</style>

<div class="mt-6 max-w-4xl w-full mx-auto pb-10">

  <!-- Tab nav -->
  <div class="flex gap-2 mb-8 bg-white rounded-2xl p-1.5 shadow-sm border border-slate-100 w-fit s-fu">
    <button class="tab-btn active text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-2" data-tab="profile">
      <span class="material-symbols-outlined text-[18px]">person</span> Profile
    </button>
    <button class="tab-btn text-sm font-semibold text-slate-500 px-5 py-2.5 rounded-xl transition-all flex items-center gap-2" data-tab="security">
      <span class="material-symbols-outlined text-[18px]">lock</span> Security
    </button>
  </div>

  <!-- ═══ PROFILE TAB ════════════════════════════════════════════════ -->
  <div id="tab-profile" class="s-tab-panel active space-y-6">

    <!-- Hero card -->
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden s-fu s-fu-1">
      <div class="h-28 bg-gradient-to-r from-[#0052FF] to-blue-400 relative">
        <div class="absolute inset-0 opacity-10"
             style="background-image:radial-gradient(circle at 20% 50%,white 1px,transparent 1px),radial-gradient(circle at 80% 20%,white 1px,transparent 1px);background-size:40px 40px;"></div>
      </div>
      <div class="px-8 pb-6 flex flex-col sm:flex-row items-end gap-5 -mt-12 relative z-10">
        <div class="relative group shrink-0">
          <div id="hero-avatar"
               class="w-24 h-24 rounded-2xl border-4 border-white shadow-xl bg-brand-blue/10 flex items-center justify-center text-brand-blue font-black text-3xl overflow-hidden select-none">
            <img id="hero-avatar-img" src="" alt="" class="hidden w-full h-full object-cover">
            <span id="hero-avatar-initials">AK</span>
          </div>
          <label for="s-avatar-upload"
            class="absolute inset-0 rounded-2xl bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">
            <span class="material-symbols-outlined text-white text-[22px]">photo_camera</span>
          </label>
          <%-- Wire to a multipart upload endpoint on the server --%>
          <input type="file" id="s-avatar-upload" accept="image/*" class="hidden">
        </div>
        <div class="flex-1 pb-1">
          <div class="flex flex-wrap items-center gap-3">
            <h2 class="text-xl font-bold text-slate-900" id="hero-name">Dr. Aryan Kapoor</h2>
            <span class="bg-mint/10 text-teal-600 font-bold text-[10px] px-2.5 py-1 rounded-full uppercase tracking-wider flex items-center gap-1">
              <span class="w-1.5 h-1.5 bg-mint rounded-full"></span> Verified
            </span>
          </div>
          <p class="text-slate-500 text-sm mt-0.5" id="hero-sub">Cardiology</p>
        </div>
        <div class="pb-1 flex items-center gap-2 text-sm text-slate-500">
          <span class="material-symbols-outlined text-brand-blue text-[18px]">military_tech</span>
          <span class="font-semibold text-slate-700" id="hero-exp">12 yrs experience</span>
        </div>
      </div>
    </div>

    <!-- Profile form -->
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 s-fu s-fu-2">
      <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
        <span class="material-symbols-outlined text-brand-blue">edit_note</span>
        Update Profile Information
      </h3>
      <%-- Action points to your update-doctor Servlet or Spring @PostMapping --%>
      <form id="profileForm" class="space-y-6"
            action="${pageContext.request.contextPath}/update-doctor"
            method="post"
            onsubmit="handleProfileSave(event)">

        <%-- CSRF token — uncomment if using Spring Security --%>
        <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> --%>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

          <!-- ── User info section ── -->
          <div class="md:col-span-2">
            <span class="text-[10px] font-bold uppercase tracking-widest text-blue-500 bg-blue-50 px-2.5 py-1 rounded-full">User info</span>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Full Name</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">person</span>
              <%-- Replace hardcoded value with ${sessionScope.doctor.name} --%>
              <input id="sf-name" name="name" type="text" value="Aryan Kapoor"
                     class="s-input w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Gender</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">wc</span>
              <%-- Use JSTL c:choose to pre-select the right option from ${sessionScope.doctor.gender} --%>
              <select id="sf-gender" name="gender"
                      class="s-select w-full pl-10 pr-8 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 appearance-none transition-all">
                <option value="Male"   selected>Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
              <span class="absolute right-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px] pointer-events-none">expand_more</span>
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Phone Number</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">call</span>
              <%-- Replace with value="${sessionScope.doctor.phone}" --%>
              <input id="sf-phone" name="phone" type="tel" value="+91 98765 43210"
                     class="s-input w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Address</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">location_on</span>
              <%-- Replace with value="${sessionScope.doctor.address}" --%>
              <input id="sf-address" name="address" type="text" value="New Delhi, India"
                     class="s-input w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            </div>
          </div>

          <!-- ── Doctor info section ── -->
          <div class="md:col-span-2 pt-2">
            <span class="text-[10px] font-bold uppercase tracking-widest text-teal-600 bg-teal-50 px-2.5 py-1 rounded-full">Doctor info</span>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Department</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">stethoscope</span>
              <select id="sf-dept" name="department"
                      class="s-select w-full pl-10 pr-8 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 appearance-none transition-all">
                <option selected>Cardiology</option>
                <option>Neurology</option>
                <option>Orthopedics</option>
                <option>Dermatology</option>
                <option>General Medicine</option>
              </select>
              <span class="absolute right-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px] pointer-events-none">expand_more</span>
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Experience (Years)</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">calendar_month</span>
              <%-- Replace with value="${sessionScope.doctor.experienceYears}" --%>
              <input id="sf-exp" name="experienceYears" type="number" min="0" max="60" value="12"
                     class="s-input w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            </div>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Qualifications</label>
            <div class="relative">
              <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">school</span>
              <%-- Replace with value="${sessionScope.doctor.qualifications}" --%>
              <input id="sf-qual" name="qualifications" type="text" value="MBBS, MD (Cardiology)"
                     class="s-input w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            </div>
          </div>

          <!-- Account Status toggle -->
          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Account Status</label>
            <div class="flex items-center gap-4 bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 h-[46px]">
              <label class="relative inline-flex items-center cursor-pointer select-none">
                <%-- Checked state can be driven by ${sessionScope.doctor.active} --%>
                <input type="checkbox" id="isActiveCheckbox" name="status"
                       class="toggle-checkbox sr-only" checked>
                <div class="toggle-track w-[44px] h-[24px] bg-slate-300 rounded-full relative">
                  <div class="toggle-thumb absolute top-[3px] left-[3px] w-[18px] h-[18px] bg-white rounded-full shadow-md"></div>
                </div>
                <span class="ml-3 text-sm font-bold text-slate-700" id="isActiveLabel">Active</span>
              </label>
            </div>
          </div>

        </div>

        <div class="flex justify-end pt-2">
          <button type="submit"
                  class="bg-brand-blue text-white font-bold px-8 py-3.5 rounded-xl shadow-lg shadow-brand-blue/25 hover:opacity-90 active:scale-95 transition-all flex items-center gap-2">
            <span class="material-symbols-outlined text-[20px]">save</span>
            Save Changes
          </button>
        </div>
      </form>
    </div>
  </div><!-- /profile -->

  <!-- ═══ SECURITY TAB ═══════════════════════════════════════════════ -->
  <div id="tab-security" class="s-tab-panel space-y-6">

    <!-- Change Password -->
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 s-fu">
      <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
        <span class="material-symbols-outlined text-brand-blue">lock_reset</span>
        Change Password
      </h3>
      <%-- Action points to your change-password Servlet or Spring @PostMapping --%>
      <form class="space-y-5"
            action="${pageContext.request.contextPath}/change-password"
            method="post"
            onsubmit="handlePasswordChange(event)">

        <%-- CSRF token — uncomment if using Spring Security --%>
        <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> --%>

        <div class="space-y-1.5">
          <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Current Password</label>
          <div class="relative">
            <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">lock</span>
            <input type="password" id="pw-current" name="currentPassword" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
                   class="s-input w-full pl-10 pr-12 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            <button type="button" class="pw-toggle absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
              <span class="material-symbols-outlined text-[18px]">visibility</span>
            </button>
          </div>
        </div>

        <div class="space-y-1.5">
          <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">New Password</label>
          <div class="relative">
            <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">lock_open</span>
            <input type="password" id="pw-new" name="newPassword" placeholder="Min. 8 characters"
                   class="s-input w-full pl-10 pr-12 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            <button type="button" class="pw-toggle absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
              <span class="material-symbols-outlined text-[18px]">visibility</span>
            </button>
          </div>
          <!-- Password strength indicator -->
          <div class="flex gap-1.5 mt-2">
            <div class="h-1 flex-1 rounded-full bg-slate-100" id="ps-1"></div>
            <div class="h-1 flex-1 rounded-full bg-slate-100" id="ps-2"></div>
            <div class="h-1 flex-1 rounded-full bg-slate-100" id="ps-3"></div>
            <div class="h-1 flex-1 rounded-full bg-slate-100" id="ps-4"></div>
          </div>
          <p class="text-[11px] text-slate-400" id="pw-strength-label"></p>
        </div>

        <div class="space-y-1.5">
          <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Confirm New Password</label>
          <div class="relative">
            <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">verified_user</span>
            <input type="password" id="pw-confirm" name="confirmPassword" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
                   class="s-input w-full pl-10 pr-12 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
            <button type="button" class="pw-toggle absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
              <span class="material-symbols-outlined text-[18px]">visibility</span>
            </button>
          </div>
        </div>

        <div class="flex justify-end pt-2">
          <button type="submit"
                  class="bg-brand-blue text-white font-bold px-8 py-3.5 rounded-xl shadow-lg shadow-brand-blue/25 hover:opacity-90 active:scale-95 transition-all flex items-center gap-2">
            <span class="material-symbols-outlined text-[20px]">lock_reset</span>
            Update Password
          </button>
        </div>
      </form>
    </div>


    <!-- Info banner -->
    <div class="bg-blue-50 rounded-2xl p-6 border border-blue-100 s-fu s-fu-2 flex gap-4 items-start">
      <span class="material-symbols-outlined text-brand-blue text-2xl mt-0.5">info</span>
      <div>
        <p class="font-bold text-blue-900 mb-1">Access Level &mdash; Doctor</p>
        <p class="text-blue-700/80 text-sm">You have full clinical access to appointments, patient records, and analytics. Contact your system administrator if you believe your access level is incorrect.</p>
      </div>
    </div>

  </div><!-- /security -->

</div>

<script>
window.__pageInit = function () {

  /* ── Tab switching ─────────────────────────────────────────────── */
  document.querySelectorAll('.tab-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      document.querySelectorAll('.tab-btn').forEach(function (b) { b.classList.remove('active'); });
      document.querySelectorAll('.s-tab-panel').forEach(function (p) { p.classList.remove('active'); });
      btn.classList.add('active');
      document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
    });
  });

  /* ── Avatar preview (client-side only) ────────────────────────── */
  document.getElementById('s-avatar-upload').addEventListener('change', function () {
    var file = this.files[0];
    if (!file) return;
    var reader = new FileReader();
    reader.onload = function (e) {
      var img = document.getElementById('hero-avatar-img');
      img.src = e.target.result;
      img.classList.remove('hidden');
      document.getElementById('hero-avatar-initials').classList.add('hidden');
    };
    reader.readAsDataURL(file);
  });

  /* ── Live hero card preview ────────────────────────────────────── */
  function updateHero() {
    var name  = document.getElementById('sf-name').value.trim();
    var dept  = document.getElementById('sf-dept').value;
    var exp   = document.getElementById('sf-exp').value;
    var words = name.split(' ').filter(Boolean);
    var ini   = words.map(function (w) { return w[0]; }).join('').toUpperCase().slice(0, 2) || 'DR';
    document.getElementById('hero-name').textContent = name ? 'Dr. ' + name : 'Dr.';
    document.getElementById('hero-sub').textContent  = dept;
    document.getElementById('hero-exp').textContent  = exp ? exp + ' yrs experience' : '';
    document.getElementById('hero-avatar-initials').textContent = ini;
  }
  ['sf-name', 'sf-dept', 'sf-exp'].forEach(function (id) {
    var el = document.getElementById(id);
    if (el) { el.addEventListener('input', updateHero); el.addEventListener('change', updateHero); }
  });

  /* ── Account status toggle ─────────────────────────────────────── */
  var toggleCb    = document.getElementById('isActiveCheckbox');
  var activeLabel = document.getElementById('isActiveLabel');
  toggleCb.addEventListener('change', function () {
    activeLabel.textContent = toggleCb.checked ? 'Active' : 'Inactive';
    activeLabel.className   = 'ml-3 text-sm font-bold ' + (toggleCb.checked ? 'text-slate-700' : 'text-red-500');
    toggleCb.value = toggleCb.checked ? 'active' : 'inactive';
  });
  toggleCb.value = 'active';

  /* ── Profile save (client-side toast; server submits via action) ─ */
  window.handleProfileSave = function (e) {
    e.preventDefault();
    /* Remove e.preventDefault() to let the form POST to the server,
       or use fetch() for an AJAX save and show the toast on success. */
    window.toast('Profile updated successfully!');
  };

  /* ── Password strength meter ───────────────────────────────────── */
  document.getElementById('pw-new').addEventListener('input', function () {
    var v = this.value;
    var score = 0;
    if (v.length >= 8)            score++;
    if (/[A-Z]/.test(v))         score++;
    if (/[0-9]/.test(v))         score++;
    if (/[^A-Za-z0-9]/.test(v))  score++;
    var colors = ['bg-red-400','bg-orange-400','bg-yellow-400','bg-mint'];
    var labels = ['','Weak','Fair','Good','Strong'];
    for (var i = 1; i <= 4; i++) {
      document.getElementById('ps-' + i).className =
        'h-1 flex-1 rounded-full ' + (i <= score ? colors[score - 1] : 'bg-slate-100');
    }
    document.getElementById('pw-strength-label').textContent = v.length ? labels[score] : '';
  });

  /* ── Show/hide password ────────────────────────────────────────── */
  document.querySelectorAll('.pw-toggle').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var input = btn.closest('.relative').querySelector('input');
      var icon  = btn.querySelector('.material-symbols-outlined');
      if (input.type === 'password') { input.type = 'text';     icon.textContent = 'visibility_off'; }
      else                           { input.type = 'password'; icon.textContent = 'visibility'; }
    });
  });

  /* ── Password change (client-side validation; server handles POST) */
  window.handlePasswordChange = function (e) {
    e.preventDefault();
    var cur = document.getElementById('pw-current').value;
    var nw  = document.getElementById('pw-new').value;
    var cf  = document.getElementById('pw-confirm').value;
    if (!cur || !nw || !cf)  { window.toast('Please fill in all password fields');       return; }
    if (nw !== cf)            { window.toast('New passwords do not match');               return; }
    if (nw.length < 8)        { window.toast('Password must be at least 8 characters'); return; }
    /* Remove e.preventDefault() above to let the form POST to the server. */
    ['pw-current','pw-new','pw-confirm'].forEach(function (id) { document.getElementById(id).value = ''; });
    for (var i = 1; i <= 4; i++) document.getElementById('ps-' + i).className = 'h-1 flex-1 rounded-full bg-slate-100';
    document.getElementById('pw-strength-label').textContent = '';
    window.toast('Password changed successfully!');
  };


};
</script>
