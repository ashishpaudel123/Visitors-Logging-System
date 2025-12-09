<%@ page import="com.visitor.system.dao.AdminDAO" %>
<%@ page import="com.visitor.system.utils.OrganizationPurposeHelper" %>
<%@ page import="java.util.List" %>
<%
// Security check - ensure user is logged in
Integer adminId = (Integer) session.getAttribute("adminId");
if (adminId == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// Get organization type for this admin
AdminDAO adminDAO = new AdminDAO();
String organizationType = adminDAO.getOrganizationType(adminId);
List<String> purposes = null;
if (organizationType != null && !organizationType.isEmpty()) {
    purposes = OrganizationPurposeHelper.getPurposesForOrganization(organizationType);
}
%>
<!DOCTYPE html>
<html class="light" lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Add New Visitor</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
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
  </head>
  <body class="font-display bg-background-light dark:bg-background-dark">
    <!-- Mobile Menu Overlay -->
    <div id="sidebar-overlay" class="fixed inset-0 bg-black/50 z-40 hidden lg:hidden" onclick="toggleSidebar()"></div>
    
    <div class="flex h-screen">
      <!-- SideNavBar -->
      <aside id="sidebar" class="fixed lg:static inset-y-0 left-0 z-50 w-64 flex-shrink-0 bg-white dark:bg-background-dark dark:border-r dark:border-slate-800 flex flex-col transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out">
        <div class="h-16 flex items-center justify-between px-6 border-b border-slate-200 dark:border-slate-800">
          <div class="flex items-center gap-3 text-slate-900 dark:text-white">
            <span class="material-symbols-outlined text-primary" style="font-variation-settings: 'FILL' 1">qr_code_scanner</span>
            <h1 class="text-lg font-bold">Visitor System</h1>
          </div>
          <button onclick="toggleSidebar()" class="lg:hidden p-1 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <nav class="flex-1 px-4 py-4">
          <div class="flex flex-col gap-2">
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="dashboard.jsp">
              <span class="material-symbols-outlined">dashboard</span>
              <p class="text-sm font-medium">Dashboard</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg bg-primary/10 text-primary" href="addVisitor.jsp">
              <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">person_add</span>
              <p class="text-sm font-semibold">Add Visitor</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/listVisitors">
              <span class="material-symbols-outlined">list_alt</span>
              <p class="text-sm font-medium">Visitor List</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="cleanLogs.jsp">
              <span class="material-symbols-outlined">delete_sweep</span>
              <p class="text-sm font-medium">Clean Old Logs</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/settings">
              <span class="material-symbols-outlined">settings</span>
              <p class="text-sm font-medium">Settings</p>
            </a>
          </div>
        </nav>
        <div class="p-4 border-t border-slate-200 dark:border-slate-800">
          <div class="flex items-center gap-3 mb-4">
            <div class="bg-primary/10 rounded-full size-10 flex items-center justify-center">
              <span class="material-symbols-outlined text-primary">person</span>
            </div>
            <div class="flex flex-col">
              <p class="text-slate-900 dark:text-white text-sm font-medium leading-normal"><%= session.getAttribute("adminUsername") != null ? session.getAttribute("adminUsername") : "Admin User" %></p>
              <p class="text-slate-500 dark:text-slate-400 text-xs font-normal leading-normal"><%= session.getAttribute("adminEmail") != null ? session.getAttribute("adminEmail") : "admin@example.com" %></p>
            </div>
          </div>
          <a href="<%= request.getContextPath() %>/logout" class="flex items-center justify-center gap-2 px-3 py-2 rounded-lg bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/30 transition-colors">
            <span class="material-symbols-outlined text-base">logout</span>
            <span class="text-sm font-medium">Logout</span>
          </a>
        </div>
      </aside>

      <!-- Main Content -->
      <div class="flex-1 flex flex-col overflow-hidden">
        <!-- Mobile Header -->
        <header class="h-16 flex lg:hidden items-center justify-between border-b border-slate-200 dark:border-slate-800 px-4 bg-white dark:bg-background-dark">
          <button onclick="toggleSidebar()" class="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800">
            <span class="material-symbols-outlined">menu</span>
          </button>
          <h2 class="text-slate-900 dark:text-white text-lg font-bold">Add Visitor</h2>
          <div class="w-10"></div>
        </header>
        <main class="flex-1 overflow-x-hidden overflow-y-auto bg-background-light dark:bg-background-dark p-4 lg:p-8">
          <div class="layout-content-container flex flex-col w-full max-w-2xl flex-1">
            <div class="flex flex-wrap justify-between gap-3 p-4">
              <p class="text-slate-900 dark:text-white text-3xl sm:text-4xl font-black leading-tight tracking-[-0.033em] min-w-72">Add New Visitor</p>
            </div>

            <div class="bg-white dark:bg-slate-800/50 p-6 sm:p-8 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/50 mt-4">
              <form method="post" action="../addVisitor" class="flex flex-col gap-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <label class="flex flex-col flex-1">
                    <p class="text-slate-800 dark:text-slate-200 text-sm font-medium leading-normal pb-2">Full Name</p>
                    <div class="flex w-full flex-1 items-stretch rounded-lg">
                      <input name="name" required class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark focus:border-primary h-12 placeholder:text-slate-400 p-[15px] rounded-r-none border-r-0 pr-2 text-base font-normal leading-normal" placeholder="John Doe" />
                      <div class="text-slate-400 flex border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark items-center justify-center pr-[15px] rounded-r-lg border-l-0">
                        <span class="material-symbols-outlined text-lg">person</span>
                      </div>
                    </div>
                  </label>

                  <label class="flex flex-col flex-1">
                    <p class="text-slate-800 dark:text-slate-200 text-sm font-medium leading-normal pb-2">Phone Number</p>
                    <div class="flex w-full flex-1 items-stretch rounded-lg">
                      <input name="phone" required class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark focus:border-primary h-12 placeholder:text-slate-400 p-[15px] rounded-r-none border-r-0 pr-2 text-base font-normal leading-normal" placeholder="+1 (555) 000-0000" />
                      <div class="text-slate-400 flex border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark items-center justify-center pr-[15px] rounded-r-lg border-l-0">
                        <span class="material-symbols-outlined text-lg">phone</span>
                      </div>
                    </div>
                  </label>
                </div>

                <div>
                  <h2 class="text-slate-800 dark:text-slate-200 text-sm font-medium leading-tight pb-2 pt-2">Purpose of Visit</h2>
                  <% if (organizationType == null || organizationType.isEmpty()) { %>
                  <div class="bg-yellow-50 border border-yellow-300 rounded-lg p-4 mb-4">
                    <div class="flex items-start">
                      <span class="material-symbols-outlined text-yellow-600 mr-3">warning</span>
                      <div>
                        <p class="text-sm font-medium text-yellow-800">Organization Type Not Set</p>
                        <p class="text-sm text-yellow-700 mt-1">Please set your organization type in <a href="<%= request.getContextPath() %>/settings" class="underline font-semibold">Settings</a> before adding visitors.</p>
                      </div>
                    </div>
                  </div>
                  <select name="purpose" required disabled class="form-select w-full h-12 rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-100 dark:bg-slate-700 text-slate-400 px-4 cursor-not-allowed">
                    <option value="">-- Set organization type first --</option>
                  </select>
                  <% } else { %>
                  <select name="purpose" required class="form-select w-full h-12 rounded-lg border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 focus:border-primary px-4">
                    <option value="">-- Select Purpose --</option>
                    <% for (String purpose : purposes) { %>
                    <option value="<%= purpose %>"><%= purpose %></option>
                    <% } %>
                  </select>
                  <% } %>
                </div>

                <div class="flex flex-col sm:flex-row-reverse items-center gap-3 border-t border-slate-200 dark:border-slate-700 pt-6 mt-4">
                  <button type="submit" <%= (organizationType == null || organizationType.isEmpty()) ? "disabled" : "" %> class="flex w-full sm:w-auto cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 <%= (organizationType == null || organizationType.isEmpty()) ? "bg-slate-400 cursor-not-allowed" : "bg-primary hover:bg-primary/90" %> text-white gap-2 text-base font-bold leading-normal tracking-[0.015em] min-w-0 px-6 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary/50 dark:focus:ring-offset-background-dark transition-colors duration-150">Save Visitor</button>
                  <a href="dashboard.jsp" class="flex w-full sm:w-auto cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 bg-transparent text-slate-600 dark:text-slate-300 gap-2 text-base font-bold leading-normal tracking-[0.015em] min-w-0 px-6 hover:bg-slate-100 dark:hover:bg-slate-700/50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500/50 dark:focus:ring-offset-background-dark transition-colors duration-150"> Cancel </a>
                </div>
              </form>
            </div>
          </div>
        </main>
      </div>
    </div>
    
    <script>
      function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebar-overlay');
        sidebar.classList.toggle('-translate-x-full');
        overlay.classList.toggle('hidden');
      }
    </script>
  </body>
</html>
