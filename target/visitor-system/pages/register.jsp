<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="light" lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Admin Registration - Visitor Entry System</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              primary: "#0f49bd",
              "background-light": "#f6f6f8",
              "background-dark": "#101622",
              "text-light": "#0d121b",
              "text-dark": "#f8f9fc",
              "text-secondary-light": "#4c669a",
              "text-secondary-dark": "#a1b1d1",
              "border-light": "#cfd7e7",
              "border-dark": "#343d50",
              "card-light": "#ffffff",
              "card-dark": "#192231",
            },
            fontFamily: {
              display: ["Inter", "sans-serif"],
            },
            borderRadius: { DEFAULT: "0.25rem", lg: "0.5rem", xl: "0.75rem", full: "9999px" },
          },
        },
      };
    </script>
    <style>
      .material-symbols-outlined {
        font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24;
        font-size: 24px;
      }
    </style>
  </head>
  <body class="font-display bg-background-light dark:bg-background-dark text-text-light dark:text-text-dark">
    <div class="relative flex min-h-screen w-full flex-col group/design-root overflow-hidden">
      <header class="absolute top-0 left-0 w-full p-4 md:px-8 md:py-6">
        <h1 class="text-sm md:text-base font-medium text-text-secondary-light dark:text-text-secondary-dark">Visitor Entry System – Admin Registration</h1>
      </header>

      <main class="flex h-full grow flex-col">
        <div class="flex flex-1 items-stretch">
          <!-- Left Side Image (hidden on mobile) -->
          <div class="hidden lg:flex lg:w-1/2 items-center justify-center bg-primary/5 p-8 dark:bg-primary/10">
            <img class="max-w-md w-full h-auto object-contain" alt="Secure registration illustration" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDwy436_trETMGI0xocUxfi6EihuhUC9WRiTc5vRji4NrAHJHKQr0jnE32n8ilwmRvtnO89tgHmYjOKQH7P_40FagYTpzh6QmbSu5kBSXGYxWS_F05XX6bmj_-_9C99Q_qCLMB-awhriDedk3w73ElpbhGkEON6RQqRyhMM9te6hf0XJOT8rKD5hRaWeOYkN-7TDiuGQqlhmZ4G3gId0ZzC6TioDEcMvW7J_Kalbf0sJMmYg6oEL52I1911UF3_5PLxW3o_H0Ur43cV" />
          </div>

          <!-- Right Side Registration Form -->
          <div class="flex flex-1 flex-col items-center justify-center p-4">
            <div class="flex flex-col w-full max-w-sm rounded-xl bg-card-light dark:bg-card-dark lg:shadow-lg lg:dark:border lg:dark:border-border-dark lg:p-10 p-6 gap-6">
              <div class="flex flex-col gap-2 text-center lg:text-left">
                <h2 class="text-text-light dark:text-text-dark text-2xl md:text-3xl font-bold leading-tight tracking-tighter">Create Admin Account</h2>
                <p class="text-text-secondary-light dark:text-text-secondary-dark text-sm leading-normal">Fill in the details below to create a new admin account.</p>
              </div>

              <!-- Error Message -->
              <% String error = request.getParameter("error"); if (error != null) { %>
              <div class="w-full p-4 rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                <div class="flex items-center gap-2">
                  <span class="material-symbols-outlined text-red-600 dark:text-red-400">error</span>
                  <p class="text-sm text-red-800 dark:text-red-300"><% if ("username".equals(error)) { %> This username is already taken. Please choose a different username. <% } else if ("email".equals(error)) { %> This email is already registered. Please use a different email or <a href="login.jsp" class="underline font-medium">login</a> instead. <% } else if ("both".equals(error)) { %> Both username and email are already registered. Please use different credentials or <a href="login.jsp" class="underline font-medium">login</a> instead. <% } else if ("exists".equals(error)) { %> Username or email already exists. <% } else if ("required".equals(error)) { %> All fields are required. <% } else if ("password".equals(error)) { %> Passwords do not match. <% } else if ("failed".equals(error)) { %> Registration failed. Please try again. <% } else { %> An error occurred. Please try again. <% } %></p>
                </div>
              </div>
              <% } %>

              <!-- Success Message -->
              <% String success = request.getParameter("success"); if (success != null && "true".equals(success)) { %>
              <div class="w-full p-4 rounded-lg bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800">
                <div class="flex items-center gap-2">
                  <span class="material-symbols-outlined text-green-600 dark:text-green-400">check_circle</span>
                  <p class="text-sm text-green-800 dark:text-green-300">Registration successful! You can now <a href="login.jsp" class="underline font-medium">login</a>.</p>
                </div>
              </div>
              <% } %>

              <!-- Registration Form -->
              <form action="<%= request.getContextPath() %>/register" method="post" class="w-full flex flex-col gap-4">
                <label class="flex flex-col w-full">
                  <p class="text-text-light dark:text-text-dark text-sm font-medium leading-normal pb-2">Username</p>
                  <div class="flex w-full items-stretch rounded-lg border border-border-light dark:border-border-dark focus-within:ring-2 focus-within:ring-primary focus-within:border-primary transition-all duration-200">
                    <div class="text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center pl-3">
                      <span class="material-symbols-outlined">person</span>
                    </div>
                    <input name="username" type="text" required class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden text-text-light dark:text-text-dark focus:outline-0 border-0 focus:ring-0 bg-transparent h-12 placeholder:text-text-secondary-light/70 dark:placeholder:text-text-secondary-dark/70 p-3 text-base font-normal leading-normal" placeholder="Choose a username" />
                  </div>
                </label>

                <label class="flex flex-col w-full">
                  <p class="text-text-light dark:text-text-dark text-sm font-medium leading-normal pb-2">Email</p>
                  <div class="flex w-full items-stretch rounded-lg border border-border-light dark:border-border-dark focus-within:ring-2 focus-within:ring-primary focus-within:border-primary transition-all duration-200">
                    <div class="text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center pl-3">
                      <span class="material-symbols-outlined">email</span>
                    </div>
                    <input name="email" type="email" required class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden text-text-light dark:text-text-dark focus:outline-0 border-0 focus:ring-0 bg-transparent h-12 placeholder:text-text-secondary-light/70 dark:placeholder:text-text-secondary-dark/70 p-3 text-base font-normal leading-normal" placeholder="Enter your email" />
                  </div>
                </label>

                <label class="flex flex-col w-full">
                  <p class="text-text-light dark:text-text-dark text-sm font-medium leading-normal pb-2">Password</p>
                  <div class="flex w-full items-stretch rounded-lg border border-border-light dark:border-border-dark focus-within:ring-2 focus-within:ring-primary focus-within:border-primary transition-all duration-200">
                    <div class="text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center pl-3">
                      <span class="material-symbols-outlined">lock</span>
                    </div>
                    <input name="password" type="password" required id="passwordInput" class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden text-text-light dark:text-text-dark focus:outline-0 border-0 focus:ring-0 bg-transparent h-12 placeholder:text-text-secondary-light/70 dark:placeholder:text-text-secondary-dark/70 p-3 text-base font-normal leading-normal" placeholder="Choose a strong password" />
                    <div class="text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center pr-3 cursor-pointer" onclick="togglePassword('passwordInput', 'visibilityIcon1')">
                      <span class="material-symbols-outlined" id="visibilityIcon1">visibility</span>
                    </div>
                  </div>
                </label>

                <label class="flex flex-col w-full">
                  <p class="text-text-light dark:text-text-dark text-sm font-medium leading-normal pb-2">Confirm Password</p>
                  <div class="flex w-full items-stretch rounded-lg border border-border-light dark:border-border-dark focus-within:ring-2 focus-within:ring-primary focus-within:border-primary transition-all duration-200">
                    <div class="text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center pl-3">
                      <span class="material-symbols-outlined">lock</span>
                    </div>
                    <input name="confirmPassword" type="password" required id="confirmPasswordInput" class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden text-text-light dark:text-text-dark focus:outline-0 border-0 focus:ring-0 bg-transparent h-12 placeholder:text-text-secondary-light/70 dark:placeholder:text-text-secondary-dark/70 p-3 text-base font-normal leading-normal" placeholder="Confirm your password" />
                    <div class="text-text-secondary-light dark:text-text-secondary-dark flex items-center justify-center pr-3 cursor-pointer" onclick="togglePassword('confirmPasswordInput', 'visibilityIcon2')">
                      <span class="material-symbols-outlined" id="visibilityIcon2">visibility</span>
                    </div>
                  </div>
                </label>

                <button type="submit" class="flex w-full cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 px-5 bg-primary text-white text-base font-bold leading-normal tracking-wide hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary focus:ring-offset-background-light dark:focus:ring-offset-background-dark transition-colors duration-200 mt-2">
                  <span class="truncate">Create Account</span>
                </button>

                <div class="text-center">
                  <p class="text-text-secondary-light dark:text-text-secondary-dark text-sm">
                    Already have an account?
                    <a href="login" class="text-primary font-medium hover:underline">Login here</a>
                  </p>
                </div>
              </form>
            </div>
          </div>
        </div>
      </main>

      <footer class="w-full p-4 text-center">
        <p class="text-xs text-text-secondary-light dark:text-text-secondary-dark">Bank-level secure system. Powered by Visitor Entry System.</p>
      </footer>
    </div>

    <script>
      function togglePassword(inputId, iconId) {
        const passwordInput = document.getElementById(inputId);
        const visibilityIcon = document.getElementById(iconId);

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          visibilityIcon.textContent = "visibility_off";
        } else {
          passwordInput.type = "password";
          visibilityIcon.textContent = "visibility";
        }
      }

      // Dark mode toggle (check system preference)
      if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.documentElement.classList.add('dark');
      }
    </script>
  </body>
</html>
