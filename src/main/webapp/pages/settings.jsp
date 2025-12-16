<%@ page import="com.visitor.system.utils.OrganizationPurposeHelper" %>
<%@ page import="java.util.List" %>
<%
// Security check - get admin ID from session
Integer adminId = (Integer) session.getAttribute("adminId");
if (adminId == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

String currentOrgType = (String) request.getAttribute("currentOrgType");
String successMessage = (String) request.getAttribute("success");
String errorMessage = (String) request.getAttribute("error");
List<String> organizationTypes = OrganizationPurposeHelper.getAllOrganizationTypes();
%>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Settings - Visitor Entry System</title>
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
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/pages/dashboard.jsp">
              <span class="material-symbols-outlined">dashboard</span>
              <p class="text-sm font-medium">Dashboard</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/pages/addVisitor.jsp">
              <span class="material-symbols-outlined">person_add</span>
              <p class="text-sm font-medium">Add Visitor</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/listVisitors">
              <span class="material-symbols-outlined">list_alt</span>
              <p class="text-sm font-medium">Visitor List</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/pages/cleanLogs.jsp">
              <span class="material-symbols-outlined">delete_sweep</span>
              <p class="text-sm font-medium">Clean Old Logs</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/report">
              <span class="material-symbols-outlined">download</span>
              <p class="text-sm font-medium">Download Report</p>
            </a>
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg bg-primary/10 text-primary" href="<%= request.getContextPath() %>/settings">
              <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">settings</span>
              <p class="text-sm font-semibold">Settings</p>
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
          <h2 class="text-slate-900 dark:text-white text-lg font-bold">Settings</h2>
          <div class="w-10"></div>
        </header>
        <main class="flex-1 overflow-x-hidden overflow-y-auto bg-background-light dark:bg-background-dark p-4 lg:p-8">
        <div class="max-w-4xl mx-auto">
            <!-- Header -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-[#0e151b]">Settings</h2>
                <p class="text-gray-600 mt-2">Configure your organization type to customize visitor purposes</p>
            </div>

            <!-- Success/Error Messages -->
            <% if (successMessage != null) { %>
            <div class="mb-6 bg-green-50 border-l-4 border-green-500 p-4 rounded">
                <div class="flex items-center">
                    <span class="material-symbols-outlined text-green-500 mr-3">check_circle</span>
                    <p class="text-green-700 font-medium"><%= successMessage %></p>
                </div>
            </div>
            <% } %>

            <% if (errorMessage != null) { %>
            <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded">
                <div class="flex items-center">
                    <span class="material-symbols-outlined text-red-500 mr-3">error</span>
                    <p class="text-red-700 font-medium"><%= errorMessage %></p>
                </div>
            </div>
            <% } %>

            <!-- Settings Form -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <form method="POST" action="<%= request.getContextPath() %>/settings">
                    <div class="mb-6">
                        <label for="organizationType" class="block text-sm font-medium text-gray-700 mb-2">
                            Organization Type
                        </label>
                        <select 
                            id="organizationType" 
                            name="organizationType" 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                            required>
                            <option value="">-- Select Organization Type --</option>
                            <% for (String orgType : organizationTypes) { %>
                            <option value="<%= orgType %>" <%= (currentOrgType != null && currentOrgType.equals(orgType)) ? "selected" : "" %>>
                                <%= orgType %>
                            </option>
                            <% } %>
                        </select>
                        <p class="mt-2 text-sm text-gray-500">
                            This will determine the available visitor purpose options in the Add Visitor form.
                        </p>
                    </div>

                    <% if (currentOrgType != null && !currentOrgType.isEmpty()) { %>
                    <div class="mb-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
                        <div class="flex items-start">
                            <span class="material-symbols-outlined text-blue-500 mr-3 mt-0.5">info</span>
                            <div>
                                <p class="text-sm text-blue-800 font-medium">Current Organization: <%= currentOrgType %></p>
                                <p class="text-sm text-blue-700 mt-1">
                                    Changing your organization type will update the purpose options available when adding new visitors.
                                </p>
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <div class="flex items-center justify-between pt-4">
                        <button 
                            type="submit" 
                            class="px-6 py-3 bg-primary text-white font-medium rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all">
                            <span class="flex items-center">
                                <span class="material-symbols-outlined mr-2">save</span>
                                Save Settings
                            </span>
                        </button>
                        <a 
                            href="<%= request.getContextPath() %>/dashboard" 
                            class="px-6 py-3 bg-gray-200 text-gray-700 font-medium rounded-lg hover:bg-gray-300 transition-all">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>

            <!-- Information Card -->
            <div class="mt-8 bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-lg font-semibold text-[#0e151b] mb-4 flex items-center">
                    <span class="material-symbols-outlined text-primary mr-2">help</span>
                    About Organization Types
                </h3>
                <div class="space-y-3 text-sm text-gray-600">
                    <p>Each organization type has a specific set of visitor purposes tailored to its needs:</p>
                    <ul class="list-disc list-inside space-y-2 ml-4">
                        <li><strong>Bank:</strong> Account opening, deposits, withdrawals, loan services, etc.</li>
                        <li><strong>School:</strong> Admission inquiries, fee payments, parent-teacher meetings, etc.</li>
                        <li><strong>College:</strong> Admission, scholarship inquiries, campus tours, etc.</li>
                        <li><strong>Office:</strong> Staff meetings, interviews, deliveries, etc.</li>
                        <li><strong>IT Company:</strong> Client meetings, technical discussions, vendor visits, etc.</li>
                        <li><strong>Government Office:</strong> Document submissions, permit applications, public services, etc.</li>
                    </ul>
                </div>
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

      // Dark mode toggle (check system preference)
      if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        document.documentElement.classList.add('dark');
      }
    </script>
</body>
</html>
