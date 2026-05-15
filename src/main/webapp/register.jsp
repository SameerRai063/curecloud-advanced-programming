<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Upachar - Create Account</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com" rel="preconnect"/>
  <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Manrope:wght@600;700&family=Public+Sans:wght@600&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "on-secondary-container": "#426878",
            "on-secondary-fixed-variant": "#244c5b",
            "on-primary-fixed": "#081d30",
            "surface-container": "#f3ede9",
            "surface-container-highest": "#e7e1dd",
            "surface-container-high": "#ede7e3",
            "on-secondary-fixed": "#001f29",
            "tertiary-fixed-dim": "#b8c9d6",
            "primary-container": "#2f4156",
            "tertiary-container": "#32424c",
            "on-secondary": "#ffffff",
            "on-background": "#1d1b19",
            "primary-fixed-dim": "#b5c8e2",
            "surface-bright": "#fef8f4",
            "surface-tint": "#4e6076",
            "surface-container-low": "#f8f2ee",
            "background": "#fef8f4",
            "tertiary-fixed": "#d4e5f2",
            "on-primary-fixed-variant": "#36485d",
            "inverse-surface": "#32302e",
            "surface": "#fef8f4",
            "error": "#ba1a1a",
            "on-tertiary-fixed-variant": "#394953",
            "outline-variant": "#c4c6cd",
            "primary": "#182b3f",
            "outline": "#74777d",
            "on-tertiary": "#ffffff",
            "on-primary": "#ffffff",
            "surface-container-lowest": "#ffffff",
            "secondary-fixed": "#c1e8fc",
            "on-error": "#ffffff",
            "on-primary-container": "#9aadc6",
            "on-tertiary-fixed": "#0d1d27",
            "inverse-primary": "#b5c8e2",
            "primary-fixed": "#d1e4ff",
            "on-surface-variant": "#44474c",
            "surface-dim": "#dfd9d5",
            "secondary-container": "#bee6f9",
            "secondary": "#3d6374",
            "on-surface": "#1d1b19",
            "tertiary": "#1c2c36",
            "on-error-container": "#93000a",
            "error-container": "#ffdad6",
            "surface-variant": "#e7e1dd",
            "on-tertiary-container": "#9daeba",
            "secondary-fixed-dim": "#a5ccdf",
            "inverse-on-surface": "#f6f0ec"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "full": "9999px",
            "2xl": "1rem",
            "3xl": "1.5rem",
            "4xl": "2rem"
          },
          "spacing": {
            "md": "24px",
            "gutter": "24px",
            "base": "8px",
            "xl": "64px",
            "xs": "4px",
            "margin": "32px",
            "lg": "40px",
            "sm": "12px",
            "2xl": "80px"
          },
          "fontFamily": {
            "headline-lg": ["Manrope"],
            "button": ["Inter"],
            "body-lg": ["Inter"],
            "headline-sm": ["Manrope"],
            "headline-md": ["Manrope"],
            "body-sm": ["Inter"],
            "body-md": ["Inter"],
            "label-md": ["Public Sans"]
          },
          "fontSize": {
            "headline-lg": ["32px", { "lineHeight": "40px", "fontWeight": "700" }],
            "button": ["16px", { "lineHeight": "24px", "fontWeight": "500" }],
            "body-lg": ["18px", { "lineHeight": "28px", "fontWeight": "400" }],
            "headline-sm": ["20px", { "lineHeight": "28px", "fontWeight": "600" }],
            "headline-md": ["24px", { "lineHeight": "32px", "fontWeight": "600" }],
            "body-sm": ["14px", { "lineHeight": "20px", "fontWeight": "400" }],
            "body-md": ["16px", { "lineHeight": "24px", "fontWeight": "400" }],
            "label-md": ["12px", { "lineHeight": "16px", "letterSpacing": "0.02em", "fontWeight": "600" }]
          },
          "boxShadow": {
            "ambient": "0 8px 30px rgba(47, 65, 86, 0.08)",
          }
        }
      }
    }
  </script>
  <style>
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
    #avatarPreview {
      transition: opacity 0.2s ease;
    }
    #uploadZone:hover {
      border-color: #3d6374;
      background-color: #f0f8fc;
    }
    #uploadZone.drag-over {
      border-color: #3d6374;
      background-color: #e0f2fb;
    }
  </style>
</head>
<body class="bg-background min-h-screen flex items-center justify-center font-body-md text-on-background">

<main class="w-full max-w-7xl mx-auto min-h-screen flex flex-col md:flex-row bg-background relative overflow-hidden shadow-[0_8px_30px_rgba(47,65,86,0.05)] border-4 border-white rounded-xl">

  <%-- Left illustration panel --%>
  <div class="hidden md:block md:w-1/2 relative bg-secondary-fixed/50 overflow-hidden">
    <div class="absolute top-gutter left-gutter z-20">
      <div class="px-sm py-xs border-2 border-surface-container-lowest rounded-md bg-transparent text-surface-container-lowest font-headline-sm tracking-widest uppercase shadow-sm">
        UPACHAR
      </div>
    </div>
    <img alt="Illustration"
         class="absolute inset-0 w-full h-full object-cover object-center mix-blend-multiply opacity-90"
         src="https://lh3.googleusercontent.com/aida/ADBb0uinVHRWTl-slXDdcxYJ-HTsgYe2dq1RpuRWoyyu77JoWgFPSeHOvLX4xQIffSYenRTcDXwqvlOg0ioN0VOxdqNGSn86rRicOEylCMBMsUfh1VR9BxyskjdR5xBRBQZir-TqR7c5nwWO1S2g8Aurml0p9ll2_XiWRfZiEJGEjbC-MSlheNGIDytH9KhkKg1P_A_mLa4aZTUmMHSYlf6yjtj9eJGTlnHh3-jsmXzLo6c4N8wBD4D5RIJJt22U"/>
    <div class="absolute inset-0 bg-gradient-to-t from-primary/40 to-transparent"></div>
  </div>

  <%-- Right form panel --%>
  <div class="w-full md:w-1/2 flex flex-col bg-surface-container-lowest rounded-tl-[3rem] md:-ml-8 z-10 p-gutter md:p-xl relative min-h-screen justify-between shadow-[0_8px_30px_rgba(47,65,86,0.08)] rounded-bl-[3rem]">
    <div class="flex-grow flex flex-col justify-center max-w-md mx-auto w-full">

      <div class="mb-lg">
        <h1 class="font-headline-lg text-primary mb-xs">Create Account</h1>
        <p class="font-body-md text-on-surface-variant">Join Upachar to manage your healthcare journey.</p>
      </div>

      <%-- enctype="multipart/form-data" required for file upload --%>
      <form action="${pageContext.request.contextPath}/register-patient"
            method="POST"
            enctype="multipart/form-data"
            class="space-y-md">

        <%-- Alert Messages --%>
        <c:if test="${not empty requestScope.errorMessage}">
          <div class="text-error font-body-sm bg-error-container p-sm rounded-lg mb-sm">
              ${requestScope.errorMessage}
          </div>
        </c:if>
        <c:if test="${not empty requestScope.successMessage}">
          <div class="text-primary font-body-sm bg-secondary-container p-sm rounded-lg mb-sm">
              ${requestScope.successMessage}
          </div>
        </c:if>

        <%-- ===== PROFILE PHOTO UPLOAD ===== --%>
        <div class="flex flex-col items-center gap-sm">
          <p class="font-label-md text-on-surface-variant self-start">Profile Photo <span class="text-outline font-normal">(optional)</span></p>

          <div class="flex items-center gap-md w-full">

            <%-- Avatar preview circle --%>
            <div class="relative flex-shrink-0">
              <div id="avatarRing"
                   class="w-20 h-20 rounded-full border-2 border-dashed border-tertiary-fixed-dim bg-surface-container flex items-center justify-center overflow-hidden">
                <%-- Default icon shown before upload --%>
                <span id="avatarIcon" class="material-symbols-outlined text-[40px] text-outline-variant">account_circle</span>
                <%-- Preview image hidden until file chosen --%>
                <img id="avatarPreview"
                     src="#" alt="Profile preview"
                     class="hidden w-full h-full object-cover rounded-full"/>
              </div>
              <%-- Remove button, shown after image selected --%>
              <button id="removePhoto" type="button"
                      class="hidden absolute -top-1 -right-1 w-6 h-6 rounded-full bg-error text-on-error flex items-center justify-center shadow-md hover:brightness-110 transition-all"
                      onclick="clearPhoto()">
                <span class="material-symbols-outlined text-[14px]">close</span>
              </button>
            </div>

            <%-- Drop zone / click to upload --%>
            <div id="uploadZone"
                 class="flex-1 border-2 border-dashed border-tertiary-fixed-dim rounded-2xl p-sm cursor-pointer transition-all bg-surface-container-low"
                 onclick="document.getElementById('profileImage').click()"
                 ondragover="handleDragOver(event)"
                 ondragleave="handleDragLeave(event)"
                 ondrop="handleDrop(event)">
              <div class="flex flex-col items-center gap-xs text-center pointer-events-none">
                <span class="material-symbols-outlined text-[28px] text-secondary">cloud_upload</span>
                <p class="font-body-sm text-on-surface-variant">
                  <span class="text-secondary font-medium">Click to upload</span> or drag & drop
                </p>
                <p class="font-label-md text-outline">JPG, PNG or WEBP · Max 10 MB</p>
                <p id="fileName" class="font-label-md text-secondary hidden"></p>
              </div>
            </div>

            <%-- Hidden actual file input — name must match servlet's getPart("profileImage") --%>
            <input type="file"
                   id="profileImage"
                   name="profileImage"
                   accept="image/jpeg,image/png,image/webp"
                   class="hidden"
                   onchange="handleFileSelect(this)"/>
          </div>
        </div>
        <%-- ===== END PROFILE PHOTO UPLOAD ===== --%>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="name">Full Name</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">person</span>
              <%-- FIX: name="name" to match servlet's getParameter("name") --%>
              <input class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md"
                     id="name" name="name" value="${param.name}" placeholder="John Doe" type="text" required/>
            </div>
          </div>
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="dob">Date of Birth</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">calendar_today</span>
              <input class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md text-on-surface-variant"
                     id="dob" name="dob" value="${param.dob}" type="date" required/>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="email">Email Address</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">mail</span>
              <input class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md"
                     id="email" name="email" value="${param.email}" placeholder="john@example.com" type="email" required/>
            </div>
          </div>
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="phone">Contact Number</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">call</span>
              <input class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md"
                     id="phone" name="phone" value="${param.phone}" placeholder="+1 (555) 000-0000" type="tel" required/>
            </div>
          </div>
        </div>

        <div>
          <label class="block font-label-md text-on-surface-variant mb-xs" for="address">Address</label>
          <div class="relative">
            <span class="material-symbols-outlined absolute left-sm top-4 text-outline-variant text-[20px]">location_on</span>
            <textarea class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md resize-none"
                      id="address" name="address" rows="2" placeholder="123 Main St, City, Country">${param.address}</textarea>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="bloodGroup">Blood Group</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">water_drop</span>
              <select class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-surface-variant focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md appearance-none"
                      id="bloodGroup" name="bloodGroup" required>
                <option disabled selected value="">Select Group</option>
                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>
              </select>
              <span class="material-symbols-outlined absolute right-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px] pointer-events-none">expand_more</span>
            </div>
          </div>
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="gender">Gender</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">wc</span>
              <select class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-4 text-on-surface-variant focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md appearance-none"
                      id="gender" name="gender" required>
                <option disabled selected value="">Select Gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="other">Other</option>
              </select>
              <span class="material-symbols-outlined absolute right-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px] pointer-events-none">expand_more</span>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="password">Password</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">lock</span>
              <input class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-10 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md"
                     id="password" name="password" placeholder="••••••••" type="password" required/>
              <button class="absolute right-sm top-1/2 -translate-y-1/2 text-outline-variant hover:text-primary transition-colors"
                      type="button" onclick="togglePassword('password', this)">
                <span class="material-symbols-outlined text-[20px]">visibility_off</span>
              </button>
            </div>
          </div>
          <div>
            <label class="block font-label-md text-on-surface-variant mb-xs" for="confirmPassword">Confirm Password</label>
            <div class="relative">
              <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant text-[20px]">lock_reset</span>
              <input class="w-full bg-surface-container-lowest border border-tertiary-fixed-dim rounded-2xl py-3 pl-10 pr-10 text-on-background focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md"
                     id="confirmPassword" name="confirmPassword" placeholder="••••••••" type="password" required/>
              <button class="absolute right-sm top-1/2 -translate-y-1/2 text-outline-variant hover:text-primary transition-colors"
                      type="button" onclick="togglePassword('confirmPassword', this)">
                <span class="material-symbols-outlined text-[20px]">visibility_off</span>
              </button>
            </div>
          </div>
        </div>

        <div class="pt-sm">
          <button class="w-full bg-primary-container text-on-primary font-button py-4 rounded-full hover:brightness-110 transition-all flex items-center justify-center gap-2 shadow-ambient"
                  type="submit">
            Sign Up
            <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
          </button>
        </div>

      </form>

      <div class="mt-lg text-center">
        <p class="font-body-sm text-on-surface-variant">
          Already have an account?
          <a class="text-secondary font-medium hover:underline transition-all" href="login.jsp">Sign In</a>
        </p>
      </div>
    </div>
  </div>
</main>

<script>
  // ── Profile photo upload ──────────────────────────────────────────
  function handleFileSelect(input) {
    if (input.files && input.files[0]) {
      applyFile(input.files[0]);
    }
  }

  function applyFile(file) {
    if (!file.type.match('image.*')) return;

    const reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById('avatarPreview').src = e.target.result;
      document.getElementById('avatarPreview').classList.remove('hidden');
      document.getElementById('avatarIcon').classList.add('hidden');
      document.getElementById('removePhoto').classList.remove('hidden');
      document.getElementById('avatarRing').classList.replace('border-dashed', 'border-solid');
      document.getElementById('fileName').textContent = file.name;
      document.getElementById('fileName').classList.remove('hidden');
    };
    reader.readAsDataURL(file);
  }

  function clearPhoto() {
    document.getElementById('profileImage').value = '';
    document.getElementById('avatarPreview').src = '#';
    document.getElementById('avatarPreview').classList.add('hidden');
    document.getElementById('avatarIcon').classList.remove('hidden');
    document.getElementById('removePhoto').classList.add('hidden');
    document.getElementById('avatarRing').classList.replace('border-solid', 'border-dashed');
    document.getElementById('fileName').classList.add('hidden');
  }

  function handleDragOver(e) {
    e.preventDefault();
    document.getElementById('uploadZone').classList.add('drag-over');
  }

  function handleDragLeave(e) {
    document.getElementById('uploadZone').classList.remove('drag-over');
  }

  function handleDrop(e) {
    e.preventDefault();
    document.getElementById('uploadZone').classList.remove('drag-over');
    const file = e.dataTransfer.files[0];
    if (file) {
      // Set the file on the real input
      const dt = new DataTransfer();
      dt.items.add(file);
      document.getElementById('profileImage').files = dt.files;
      applyFile(file);
    }
  }

  // ── Password visibility toggle ────────────────────────────────────
  function togglePassword(fieldId, btn) {
    const input = document.getElementById(fieldId);
    const icon  = btn.querySelector('.material-symbols-outlined');
    if (input.type === 'password') {
      input.type = 'text';
      icon.textContent = 'visibility';
    } else {
      input.type = 'password';
      icon.textContent = 'visibility_off';
    }
  }
</script>

</body>
</html>
