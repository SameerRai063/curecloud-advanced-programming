<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Upachar Login Page</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Manrope:wght@600;700&family=Public+Sans:wght@600&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-secondary-container": "#426878",
                        "primary-fixed-dim": "#b5c8e2",
                        "on-background": "#1d1b19",
                        "on-secondary": "#ffffff",
                        "error-container": "#ffdad6",
                        "on-tertiary-fixed": "#0d1d27",
                        "on-primary-fixed-variant": "#36485d",
                        "on-primary-fixed": "#081d30",
                        "on-tertiary-container": "#9daeba",
                        "surface-container": "#f3ede9",
                        "tertiary-fixed-dim": "#b8c9d6",
                        "primary": "#182b3f",
                        "on-secondary-fixed-variant": "#244c5b",
                        "primary-container": "#2f4156",
                        "surface-dim": "#dfd9d5",
                        "on-primary": "#ffffff",
                        "surface-container-high": "#ede7e3",
                        "secondary-fixed": "#c1e8fc",
                        "on-tertiary-fixed-variant": "#394953",
                        "outline-variant": "#c4c6cd",
                        "on-secondary-fixed": "#001f29",
                        "surface-tint": "#4e6076",
                        "secondary": "#3d6374",
                        "on-error": "#ffffff",
                        "surface-variant": "#e7e1dd",
                        "on-primary-container": "#9aadc6",
                        "inverse-on-surface": "#f6f0ec",
                        "secondary-fixed-dim": "#a5ccdf",
                        "error": "#ba1a1a",
                        "inverse-surface": "#32302e",
                        "secondary-container": "#bee6f9",
                        "primary-fixed": "#d1e4ff",
                        "on-surface": "#1d1b19",
                        "background": "#fef8f4",
                        "surface-bright": "#fef8f4",
                        "surface-container-highest": "#e7e1dd",
                        "outline": "#74777d",
                        "on-tertiary": "#ffffff",
                        "tertiary": "#1c2c36",
                        "surface-container-lowest": "#ffffff",
                        "on-error-container": "#93000a",
                        "surface-container-low": "#f8f2ee",
                        "surface": "#fef8f4",
                        "on-surface-variant": "#44474c",
                        "inverse-primary": "#b5c8e2",
                        "tertiary-fixed": "#d4e5f2",
                        "tertiary-container": "#32424c"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "xl": "64px",
                        "gutter": "24px",
                        "lg": "40px",
                        "margin": "32px",
                        "md": "24px",
                        "base": "8px",
                        "xs": "4px",
                        "sm": "12px"
                    },
                    "fontFamily": {
                        "headline-lg": [
                            "Manrope"
                        ],
                        "body-lg": [
                            "Inter"
                        ],
                        "body-sm": [
                            "Inter"
                        ],
                        "headline-sm": [
                            "Manrope"
                        ],
                        "button": [
                            "Inter"
                        ],
                        "label-md": [
                            "Public Sans"
                        ],
                        "headline-md": [
                            "Manrope"
                        ],
                        "body-md": [
                            "Inter"
                        ]
                    },
                    "fontSize": {
                        "headline-lg": [
                            "32px",
                            {
                                "lineHeight": "40px",
                                "fontWeight": "700"
                            }
                        ],
                        "body-lg": [
                            "18px",
                            {
                                "lineHeight": "28px",
                                "fontWeight": "400"
                            }
                        ],
                        "body-sm": [
                            "14px",
                            {
                                "lineHeight": "20px",
                                "fontWeight": "400"
                            }
                        ],
                        "headline-sm": [
                            "20px",
                            {
                                "lineHeight": "28px",
                                "fontWeight": "600"
                            }
                        ],
                        "button": [
                            "16px",
                            {
                                "lineHeight": "24px",
                                "fontWeight": "500"
                            }
                        ],
                        "label-md": [
                            "12px",
                            {
                                "lineHeight": "16px",
                                "letterSpacing": "0.02em",
                                "fontWeight": "600"
                            }
                        ],
                        "headline-md": [
                            "24px",
                            {
                                "lineHeight": "32px",
                                "fontWeight": "600"
                            }
                        ],
                        "body-md": [
                            "16px",
                            {
                                "lineHeight": "24px",
                                "fontWeight": "400"
                            }
                        ]
                    }
                },
            },
        }
    </script>
</head>
<body class="bg-background min-h-screen flex items-center justify-center font-body-md text-body-md text-on-surface">
<div class="w-full max-w-7xl mx-auto min-h-screen flex flex-col md:flex-row bg-background relative overflow-hidden shadow-[0_8px_30px_rgba(47,65,86,0.05)] border-4 border-white rounded-xl">
    <div class="hidden md:block md:w-1/2 relative bg-surface-variant"><div class="absolute top-gutter left-gutter z-20">
        <div class="border border-white/80 rounded-[4px] px-md py-sm bg-transparent backdrop-blur-sm">
            <span class="font-headline-sm text-white tracking-widest font-bold">UPACHAR</span>
        </div>
    </div>
        <img alt="A high-quality 3D minimalist illustration of a friendly doctor advising a patient." class="absolute inset-0 w-full h-full object-cover" data-alt="A high-quality 3D minimalist illustration of a friendly doctor advising a patient. Smooth, matte 3D clay render, modern corporate UI web illustration style. Characters are stylized, modern, faceless or with minimal features. Doctor wearing a white coat, sitting across from a patient in a comfortable, abstract clinical setting. Soft studio lighting, smooth gradient shadows. Solid soft sky-blue background with plenty of negative space at the top and left. Clean healthcare aesthetic, 8k, Blender 3D style." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCDDeFkvl4CxBUr3zaFSzFsT0cQ5F4zKop32QPPR8Z5Ly4-S2JJMeICQRblzN0R2bVfb6VQP3dkswA5EYb-20wq2eO692EREzOYPDQKRRoXbveMgWv3NeaNRzq4WwkRqTYYNE-DJi16BSQIe94MhQJyks1jcPPEbKUdzLbh0tSZeu2Jc2sG4GBK-eKMoS0WkVnHPoQY9e7RMP45bNpOE7Tcxp1mwfh3dThQmOPYx6EUN3lgwYSE90-2vf2ariFt2KzxvT8H9h2o83cU"/>
        <div class="absolute inset-0 bg-primary/10"></div>
    </div>
    <div class="w-full md:w-1/2 flex flex-col bg-surface-container-lowest rounded-tl-[3rem] md:-ml-8 z-10 p-gutter md:p-xl relative min-h-screen justify-between shadow-[0_8px_30px_rgba(47,65,86,0.08)] rounded-bl-[3rem]">
        <div class="flex-grow flex flex-col justify-center max-w-md mx-auto w-full">
            <div class="mb-lg">
                <h1 class="font-headline-lg text-headline-lg text-primary-container mb-base">Welcome Back</h1>
                <p class="font-body-lg text-body-lg text-on-surface-variant">Please enter your details to access your account.</p>
            </div>

            <%-- Form updated with action, method, and conditional error message display --%>
            <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-md">

                <%-- JSTL conditional to display error messages safely --%>
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="text-error font-body-sm bg-error-container p-sm rounded-lg">
                            ${requestScope.errorMessage}
                    </div>
                </c:if>

                <div class="space-y-xs">
                    <label class="font-label-md text-label-md text-on-surface-variant block" for="email">Email Address</label>
                    <div class="relative">
                        <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant">mail</span>
                        <%-- Added name="email" and value="${param.email}" --%>
                        <input class="w-full pl-lg pr-sm py-sm bg-surface-container-lowest border border-outline-variant rounded-lg focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md text-body-md text-on-surface placeholder:text-outline-variant" id="email" name="email" value="${param.email}" placeholder="Enter your email" type="email" required/>
                    </div>
                </div>
                <div class="space-y-xs">
                    <label class="font-label-md text-label-md text-on-surface-variant block" for="password">Password</label>
                    <div class="relative">
                        <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline-variant">lock</span>
                        <%-- Added name="password" --%>
                        <input class="w-full pl-lg pr-sm py-sm bg-surface-container-lowest border border-outline-variant rounded-lg focus:border-secondary focus:ring-1 focus:ring-secondary outline-none transition-colors font-body-md text-body-md text-on-surface placeholder:text-outline-variant" id="password" name="password" placeholder="••••••••" type="password" required/>
                    </div>
                </div>
                <div class="flex items-center justify-end">
                    <a class="font-label-md text-label-md text-secondary hover:text-primary-container transition-colors" href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
                </div>
                <div class="pt-base">
                    <button class="w-full bg-primary-container text-on-primary font-button text-button py-sm px-gutter rounded-full hover:brightness-110 transition-all flex justify-center items-center gap-xs shadow-[0_4px_20px_rgba(47,65,86,0.15)]" type="submit">
                        Sign In
                        <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
                    </button>
                </div><div class="mt-md text-center">
                <p class="font-body-md text-body-md text-on-surface-variant">
                    Don't have an account?
                    <a class="font-label-md text-label-md text-secondary hover:text-primary-container transition-colors ml-xs" href="register.jsp">Sign Up</a>
                </p>
            </div>
            </form>
        </div>
        <div class="mt-lg text-center">
            <%-- Replaced hardcoded '2024' with dynamic Java year processing --%>
            <p class="font-body-sm text-body-sm text-outline">© <%= java.time.Year.now().getValue() %> Upachar Hospital Management. All rights reserved.</p>
        </div>
    </div>
</div>
</body></html>