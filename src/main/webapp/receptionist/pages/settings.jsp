<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%--
  Server-side hint: bind receptionist data in the servlet and expose via:
    request.setAttribute("receptionist", receptionistObj);
  Then use EL below, e.g.: ${receptionist.name}, ${receptionist.phone}, etc.
--%>

<div id="settings-root" class="mt-6 max-w-4xl w-full mx-auto pb-10">

  <%-- ===== Tab Navigation ===== --%>
  <div class="flex gap-2 mb-8 bg-white rounded-2xl p-1.5 shadow-sm border border-slate-100 w-fit">
    <button class="tab-btn active text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-2
                   bg-brand-blue text-white shadow-lg shadow-blue-500/20" data-tab="profile">
      <span class="material-symbols-outlined text-[18px]">person</span> Profile
    </button>
    <button class="tab-btn text-sm font-semibold text-slate-500 px-5 py-2.5 rounded-xl transition-all flex items-center gap-2
                   hover:bg-slate-50" data-tab="security">
      <span class="material-symbols-outlined text-[18px]">lock</span> Security
    </button>
  </div>

  <%-- ===== Profile Tab ===== --%>
  <div id="tab-profile" class="tab-panel space-y-6">

    <%-- Hero / Avatar Card --%>
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
      <div class="h-28 bg-gradient-to-r from-brand-blue to-blue-400 relative"></div>
      <div class="px-8 pb-6 flex flex-col sm:flex-row items-end gap-5 -mt-12 relative z-10">

        <div class="relative group shrink-0">
          <div id="hero-avatar"
               class="w-24 h-24 rounded-2xl border-4 border-white shadow-xl bg-slate-100 flex items-center justify-center
                      text-brand-blue font-black text-3xl overflow-hidden">
            <span id="hero-avatar-initials">AK</span>
          </div>
          <label for="profileImage"
                 class="absolute inset-0 rounded-2xl bg-black/40 flex items-center justify-center
                        opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer"
                 title="Change profile picture">
            <span class="material-symbols-outlined text-white text-[22px]">photo_camera</span>
          </label>
        </div>

        <div class="flex-1 pb-1">
          <h2 class="text-xl font-bold text-slate-900" id="hero-name">Aryan Kapoor</h2>
          <p class="text-slate-500 text-sm mt-0.5">Front Desk Administration</p>
        </div>
      </div>
    </div>

    <%-- Personal Information Form --%>
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8">
      <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
        <span class="material-symbols-outlined text-brand-blue">badge</span>
        Personal Information
      </h3>

      <form id="profileForm" action="update-receptionist" method="POST" enctype="multipart/form-data" class="space-y-6">
        <input type="hidden" name="oldProfileImage" value="default.png" />
        <input type="file"   id="profileImage" name="profileImage" class="hidden" accept="image/*" />

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

          <div class="space-y-1.5">
            <label for="inputName" class="text-xs font-bold text-slate-500 uppercase tracking-wider">Full Name</label>
            <input id="inputName" name="name" type="text" value="Aryan Kapoor" required
              class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm
                     focus:ring-2 focus:ring-brand-blue/20 outline-none transition-all" />
          </div>

          <div class="space-y-1.5">
            <label for="inputGender" class="text-xs font-bold text-slate-500 uppercase tracking-wider">Gender</label>
            <select id="inputGender" name="gender"
              class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm
                     focus:ring-2 focus:ring-brand-blue/20 outline-none transition-all">
              <option value="Male"   selected>Male</option>
              <option value="Female">Female</option>
              <option value="Other">Other</option>
            </select>
          </div>

          <div class="space-y-1.5">
            <label for="inputPhone" class="text-xs font-bold text-slate-500 uppercase tracking-wider">Phone Number</label>
            <input id="inputPhone" name="phone" type="tel" value="+91 98765 43210"
              class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm
                     focus:ring-2 focus:ring-brand-blue/20 outline-none transition-all" />
          </div>

          <div class="space-y-1.5">
            <label for="inputAddress" class="text-xs font-bold text-slate-500 uppercase tracking-wider">Address</label>
            <input id="inputAddress" name="address" type="text" value="New Delhi, India"
              class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm
                     focus:ring-2 focus:ring-brand-blue/20 outline-none transition-all" />
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Account Status</label>
            <div class="flex items-center gap-3 bg-slate-50 border border-slate-200 rounded-xl px-4 py-3">
              <span class="size-2 rounded-full bg-mint"></span>
              <span class="text-sm font-bold text-slate-700">Active</span>
              <input type="hidden" name="status" value="active" />
            </div>
          </div>

        </div>

        <div class="flex justify-end pt-4">
          <button type="submit"
            class="bg-brand-blue text-white font-bold px-8 py-3.5 rounded-xl shadow-lg shadow-blue-500/20
                   hover:opacity-90 transition-all flex items-center gap-2">
            <span class="material-symbols-outlined text-[20px]">save</span>
            Save Changes
          </button>
        </div>
      </form>
    </div>
  </div>

  <%-- ===== Security Tab ===== --%>
  <div id="tab-security" class="tab-panel hidden space-y-6">
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8">
      <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
        <span class="material-symbols-outlined text-brand-blue">lock_reset</span>
        Update Credentials
      </h3>

      <%--
        Action should point to the password-change servlet, e.g.:
          action="change-password" method="POST"
        Server-side: validate currentPassword, hash newPassword, update DB.
      --%>
      <form id="securityForm" action="change-password" method="POST" class="space-y-5">

        <div class="space-y-1.5">
          <label for="currentPassword" class="text-xs font-bold text-slate-500 uppercase tracking-wider">Current Password</label>
          <input id="currentPassword" type="password" name="currentPassword" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
            required minlength="8"
            class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm
                   focus:ring-2 focus:ring-brand-blue/20 outline-none transition-all" />
        </div>

        <div class="space-y-1.5">
          <label for="newPassword" class="text-xs font-bold text-slate-500 uppercase tracking-wider">New Password</label>
          <input id="newPassword" type="password" name="newPassword" placeholder="Minimum 8 characters"
            required minlength="8"
            class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm
                   focus:ring-2 focus:ring-brand-blue/20 outline-none transition-all" />
        </div>

        <div class="flex justify-end pt-4">
          <button type="submit"
            class="bg-slate-800 text-white font-bold px-8 py-3.5 rounded-xl hover:bg-slate-900 transition-all">
            Update Password
          </button>
        </div>
      </form>
    </div>
  </div>

</div>

<%-- ===== Settings Page Script ===== --%>
<script>
window.__pageInit = function () {

  /* ---------- Tab switching ---------- */
  var tabs   = document.querySelectorAll('.tab-btn');
  var panels = document.querySelectorAll('.tab-panel');

  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {

      /* Reset all tabs */
      tabs.forEach(function (t) {
        t.classList.remove('active', 'bg-brand-blue', 'text-white', 'shadow-lg', 'shadow-blue-500/20');
        t.classList.add('text-slate-500', 'hover:bg-slate-50');
      });

      /* Activate clicked tab */
      tab.classList.add('active', 'bg-brand-blue', 'text-white', 'shadow-lg', 'shadow-blue-500/20');
      tab.classList.remove('text-slate-500', 'hover:bg-slate-50');

      /* Show matching panel */
      panels.forEach(function (p) { p.classList.add('hidden'); });
      document.getElementById('tab-' + tab.dataset.tab).classList.remove('hidden');
    });
  });

  /* ---------- Live hero preview on name input ---------- */
  var nameInput = document.getElementById('inputName');
  if (nameInput) {
    nameInput.addEventListener('input', function () {
      var val = this.value.trim() || 'Receptionist';
      document.getElementById('hero-name').textContent          = val;
      document.getElementById('hero-avatar-initials').textContent = window.initials(val);
    });
  }

  /* ---------- Security form: client-side guard ---------- */
  var securityForm = document.getElementById('securityForm');
  if (securityForm) {
    securityForm.addEventListener('submit', function (e) {
      var current = document.getElementById('currentPassword').value;
      var next    = document.getElementById('newPassword').value;

      if (!current || !next) {
        e.preventDefault();
        if (typeof window.toast === 'function') {
          window.toast('Please fill in both password fields.', 'error');
        }
        return;
      }

      if (next.length < 8) {
        e.preventDefault();
        if (typeof window.toast === 'function') {
          window.toast('New password must be at least 8 characters.', 'error');
        }
      }
      /* Form submits to change-password servlet on pass */
    });
  }
};
</script>
