<%@ page import="com.visitor.system.dao.VisitorDAO" %>
<%
    VisitorDAO dao = new VisitorDAO();
    int totalVisitors = dao.getTotalVisitorCount();
    
    String daysParam = request.getParameter("days");
    int days = 30; // default
    try {
        if (daysParam != null && !daysParam.isEmpty()) {
            days = Integer.parseInt(daysParam);
        }
    } catch (NumberFormatException e) {
        days = 30;
    }
    
    int oldVisitors = dao.getOldVisitorCount(days);
    
    String cleaned = request.getParameter("cleaned");
    String deletedCountParam = request.getParameter("count");
%>
<!DOCTYPE html>
<html class="light" lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Clean Old Logs - Visitor Entry System</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
      rel="stylesheet"
    />
    <script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              primary: "#137fec",
              "background-light": "#f6f7f8",
              "background-dark": "#101922",
            },
            fontFamily: {
              display: ["Inter", "sans-serif"],
            },
            borderRadius: {
              DEFAULT: "0.25rem",
              lg: "0.5rem",
              xl: "0.75rem",
              full: "9999px",
            },
          },
        },
      };
    </script>
    <style>
      .material-symbols-outlined {
        font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24;
      }
    </style>
  </head>
  <body class="font-display">
    <div
      class="relative flex h-auto min-h-screen w-full flex-col bg-background-light dark:bg-background-dark group/design-root overflow-x-hidden"
    >
      <div class="layout-container flex h-full grow flex-col">
        <div
          class="flex flex-1 justify-center p-4 sm:p-6 md:p-8 lg:py-12 lg:px-40"
        >
          <div
            class="layout-content-container flex flex-col max-w-[960px] flex-1 gap-8"
          >
            <!-- Header -->
            <div class="flex flex-wrap justify-between items-start gap-4">
              <div class="flex flex-col gap-2">
                <p
                  class="text-slate-900 dark:text-slate-50 text-3xl sm:text-4xl font-black leading-tight tracking-[-0.033em]"
                >
                  Clean Old Logs
                </p>
                <p
                  class="text-slate-500 dark:text-slate-400 text-base font-normal leading-normal"
                >
                  Remove visitor entries older than a specific number of days.
                </p>
              </div>
              <a
                href="dashboard.jsp"
                class="flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
              >
                <span class="material-symbols-outlined text-xl"
                  >arrow_back</span
                >
                <span>Back to Dashboard</span>
              </a>
            </div>

            <!-- Stats Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div
                class="flex flex-1 flex-col gap-4 rounded-xl p-6 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/50"
              >
                <div class="flex items-center gap-3">
                  <span
                    class="material-symbols-outlined text-slate-500 dark:text-slate-400"
                    >groups</span
                  >
                  <p
                    class="text-slate-700 dark:text-slate-300 text-base font-medium leading-normal"
                  >
                    Total visitors in the system
                  </p>
                </div>
                <p
                  class="text-slate-900 dark:text-slate-50 tracking-tight text-3xl font-bold leading-tight"
                >
                  <%= totalVisitors %>
                </p>
              </div>
              <div
                class="flex flex-1 flex-col gap-4 rounded-xl p-6 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/50"
              >
                <div class="flex items-center gap-3">
                  <span
                    class="material-symbols-outlined text-slate-500 dark:text-slate-400"
                    >calendar_clock</span
                  >
                  <p
                    class="text-slate-700 dark:text-slate-300 text-base font-medium leading-normal"
                  >
                    Visitors older than
                    <span id="display-days"><%= days %></span> days
                  </p>
                </div>
                <p
                  class="text-slate-900 dark:text-slate-50 tracking-tight text-3xl font-bold leading-tight"
                  id="old-visitors-count"
                >
                  <%= oldVisitors %>
                </p>
              </div>
            </div>

            <div
              class="border-t border-slate-200 dark:border-slate-800 my-4"
            ></div>

            <!-- Clean Logs Form -->
            <div class="flex flex-col items-start gap-6">
              <div class="flex flex-col gap-3 w-full max-w-sm">
                <label
                  class="text-slate-700 dark:text-slate-300 text-base font-medium"
                  for="days-input"
                  >Enter number of days:</label
                >
                <input
                  class="w-full rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900/50 px-4 py-2 text-slate-900 dark:text-slate-50 shadow-sm focus:border-primary focus:ring-primary"
                  id="days-input"
                  type="number"
                  min="1"
                  value="<%= days %>"
                  onchange="updateOldCount(this.value)"
                />
              </div>
              <p class="text-slate-500 dark:text-slate-400 text-sm">
                Clicking the button below will open a confirmation dialog to
                permanently remove old visitor logs from the system based on the
                number of days specified.
              </p>
              <button
                onclick="showConfirmDialog()"
                class="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center gap-2 overflow-hidden rounded-lg h-12 px-6 bg-primary text-white text-base font-bold leading-normal tracking-[0.015em] shadow-sm hover:bg-primary/90 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary"
              >
                <span class="material-symbols-outlined">delete_sweep</span>
                <span class="truncate">Clean Logs</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Confirmation Dialog (Hidden by default) -->
    <div
      id="confirm-dialog"
      class="fixed inset-0 z-50 hidden items-center justify-center bg-black/60 p-4"
    >
      <div
        class="flex w-full max-w-md flex-col gap-6 rounded-xl bg-white dark:bg-slate-900 p-6 shadow-2xl"
      >
        <div class="flex flex-col gap-3">
          <h3 class="text-xl font-bold text-slate-900 dark:text-slate-50">
            Confirm Deletion
          </h3>
          <p class="text-slate-500 dark:text-slate-400">
            Are you sure you want to permanently delete visitor logs older than
            <span
              class="font-bold text-slate-700 dark:text-slate-300"
              id="confirm-days"
              ><%= days %></span
            >
            days? This action cannot be undone.
          </p>
        </div>
        <div
          class="flex w-full flex-col-reverse sm:flex-row sm:justify-end gap-3"
        >
          <button
            onclick="hideConfirmDialog()"
            class="flex h-10 items-center justify-center rounded-lg border border-slate-300 dark:border-slate-700 bg-transparent px-4 text-sm font-semibold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
          >
            Cancel
          </button>
          <button
            onclick="submitCleanForm()"
            class="flex h-10 items-center justify-center rounded-lg bg-red-600 px-4 text-sm font-semibold text-white shadow-sm hover:bg-red-500"
          >
            Confirm &amp; Clean
          </button>
        </div>
      </div>
    </div>

    <!-- Success Toast (Hidden by default) -->
    <% if ("1".equals(cleaned)) { %>
    <div
      id="success-toast"
      class="fixed bottom-5 right-5 z-50 flex items-center gap-3 rounded-lg bg-slate-900 dark:bg-slate-50 p-4 text-white dark:text-slate-900 shadow-lg"
    >
      <span class="material-symbols-outlined text-green-400 dark:text-green-500"
        >check_circle</span
      >
      <p class="text-sm font-medium">
        Old logs older than
        <span class="font-semibold"><%= daysParam %></span> days cleaned
        successfully! (<%= deletedCountParam %> records deleted)
      </p>
    </div>
    <script>
      setTimeout(() => {
        const toast = document.getElementById("success-toast");
        if (toast) {
          toast.style.opacity = "0";
          toast.style.transition = "opacity 0.5s";
          setTimeout(() => toast.remove(), 500);
        }
      }, 5000);
    </script>
    <% } %>

    <!-- Hidden Form for Submission -->
    <form
      id="clean-form"
      method="POST"
      action="../cleanLogs"
      style="display: none"
    >
      <input type="hidden" name="days" id="form-days" value="<%= days %>" />
    </form>

    <script>
      function showConfirmDialog() {
        const days = document.getElementById("days-input").value;
        document.getElementById("confirm-days").textContent = days;
        document.getElementById("form-days").value = days;
        document.getElementById("confirm-dialog").classList.remove("hidden");
        document.getElementById("confirm-dialog").classList.add("flex");
      }

      function hideConfirmDialog() {
        document.getElementById("confirm-dialog").classList.remove("flex");
        document.getElementById("confirm-dialog").classList.add("hidden");
      }

      function submitCleanForm() {
        document.getElementById("clean-form").submit();
      }

      async function updateOldCount(days) {
        document.getElementById("display-days").textContent = days;
        document.getElementById("form-days").value = days;
        // Reload page with new days parameter to update count
        window.location.href = "cleanLogs.jsp?days=" + days;
      }
    </script>
  </body>
</html>
