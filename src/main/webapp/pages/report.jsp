<%@ page import="com.visitor.system.dao.VisitorDAO" %>
<%@ page import="com.visitor.system.model.Visitor" %>
<%@ page import="java.util.List" %>
<%
// Security check - get admin ID from session
Integer adminId = (Integer) session.getAttribute("adminId");
if (adminId == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// Get visitor count for display
VisitorDAO dao = new VisitorDAO();
int totalVisitors = dao.getTotalVisitorCount(adminId);

// Get error message if any
String error = (String) request.getAttribute("error");
String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Visitor Report - Secure Download</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script>
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
            <a class="flex items-center gap-3 px-3 py-2 rounded-lg bg-primary/10 text-primary" href="<%= request.getContextPath() %>/report">
              <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">download</span>
              <p class="text-sm font-semibold">Download Report</p>
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
            <!-- TopNavBar -->
            <header class="h-16 flex items-center justify-between whitespace-nowrap border-b border-solid border-slate-200 dark:border-slate-800 px-4 lg:px-8 bg-white dark:bg-background-dark">
                <div class="flex items-center gap-4">
                    <button onclick="toggleSidebar()" class="lg:hidden p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800">
                        <span class="material-symbols-outlined">menu</span>
                    </button>
                    <h2 class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Visitor Report</h2>
                </div>
            </header>

            <main class="flex-1 overflow-x-hidden overflow-y-auto bg-background-light dark:bg-background-dark p-8">
                <div class="max-w-2xl mx-auto">
                    <!-- Security Notice Card -->
                    <div class="rounded-xl border border-amber-200 dark:border-amber-800 bg-amber-50 dark:bg-amber-900/20 p-6 mb-8">
                        <div class="flex items-start gap-4">
                            <div class="bg-amber-100 dark:bg-amber-900/40 rounded-full p-3">
                                <span class="material-symbols-outlined text-amber-600 dark:text-amber-400" style="font-variation-settings: 'FILL' 1">shield_lock</span>
                            </div>
                            <div>
                                <h3 class="text-amber-800 dark:text-amber-300 font-semibold text-lg mb-2">Secure Report Access</h3>
                                <p class="text-amber-700 dark:text-amber-400 text-sm">
                                    For security purposes, you must re-enter your password to download visitor reports. 
                                    This protects sensitive visitor data from unauthorized access.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Report Form Card -->
                    <div class="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40 overflow-hidden">
                        <div class="px-6 py-5 border-b border-slate-200 dark:border-slate-800">
                            <div class="flex items-center gap-3">
                                <span class="material-symbols-outlined text-primary text-2xl" style="font-variation-settings: 'FILL' 1">download</span>
                                <div>
                                    <h2 class="text-slate-900 dark:text-white text-xl font-bold">Download Visitor Report</h2>
                                    <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Generate and download visitor data as CSV</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="p-6">
                            <!-- Stats Display -->
                            <div class="grid grid-cols-2 gap-4 mb-6">
                                <div class="bg-slate-50 dark:bg-slate-800/50 rounded-lg p-4">
                                    <p class="text-slate-500 dark:text-slate-400 text-xs uppercase tracking-wider mb-1">Total Records</p>
                                    <p class="text-slate-900 dark:text-white text-2xl font-bold"><%= totalVisitors %></p>
                                </div>
                                <div class="bg-slate-50 dark:bg-slate-800/50 rounded-lg p-4">
                                    <p class="text-slate-500 dark:text-slate-400 text-xs uppercase tracking-wider mb-1">Logged in as</p>
                                    <p class="text-slate-900 dark:text-white text-lg font-semibold truncate"><%= session.getAttribute("adminUsername") %></p>
                                </div>
                            </div>

                            <!-- Error Message -->
                            <% if (error != null && !error.isEmpty()) { %>
                            <div class="mb-6 p-4 rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-red-500 dark:text-red-400">error</span>
                                    <p class="text-red-700 dark:text-red-300 text-sm font-medium"><%= error %></p>
                                </div>
                            </div>
                            <% } %>

                            <!-- Success Message -->
                            <% if ("true".equals(success)) { %>
                            <div class="mb-6 p-4 rounded-lg bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800">
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-green-500 dark:text-green-400">check_circle</span>
                                    <p class="text-green-700 dark:text-green-300 text-sm font-medium">Report downloaded successfully!</p>
                                </div>
                            </div>
                            <% } %>

                            <!-- Report Form -->
                            <form action="<%= request.getContextPath() %>/report" method="POST" class="space-y-6">
                                <!-- Password Field -->
                                <div>
                                    <label class="block text-slate-700 dark:text-slate-300 text-sm font-semibold mb-2" for="password">
                                        <span class="flex items-center gap-2">
                                            <span class="material-symbols-outlined text-base">lock</span>
                                            Password Verification
                                        </span>
                                    </label>
                                    <div class="relative">
                                        <input 
                                            type="password" 
                                            id="password" 
                                            name="password" 
                                            required
                                            autocomplete="current-password"
                                            class="w-full px-4 py-3 pl-11 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                            placeholder="Enter your password to verify identity"
                                        />
                                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">password</span>
                                    </div>
                                    <p class="text-slate-500 dark:text-slate-400 text-xs mt-2">Required for security verification</p>
                                </div>

                                <!-- Days Field -->
                                <div>
                                    <label class="block text-slate-700 dark:text-slate-300 text-sm font-semibold mb-2" for="days">
                                        <span class="flex items-center gap-2">
                                            <span class="material-symbols-outlined text-base">date_range</span>
                                            Report Period (Days)
                                        </span>
                                    </label>
                                    <div class="relative">
                                        <input 
                                            type="number" 
                                            id="days" 
                                            name="days" 
                                            required
                                            min="1" 
                                            max="365" 
                                            value="30"
                                            class="w-full px-4 py-3 pl-11 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all"
                                            placeholder="Enter number of days"
                                        />
                                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">calendar_month</span>
                                    </div>
                                    <p class="text-slate-500 dark:text-slate-400 text-xs mt-2">Enter 7 for last week, 30 for last month, or any custom number (1-365)</p>
                                </div>

                                <!-- Quick Select Buttons -->
                                <div>
                                    <p class="text-slate-600 dark:text-slate-400 text-xs font-medium mb-2">Quick Select:</p>
                                    <div class="flex flex-wrap gap-2">
                                        <button type="button" onclick="setDays(7)" class="px-3 py-1.5 text-xs font-medium rounded-full border border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
                                            Last 7 Days
                                        </button>
                                        <button type="button" onclick="setDays(14)" class="px-3 py-1.5 text-xs font-medium rounded-full border border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
                                            Last 14 Days
                                        </button>
                                        <button type="button" onclick="setDays(30)" class="px-3 py-1.5 text-xs font-medium rounded-full border border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
                                            Last 30 Days
                                        </button>
                                        <button type="button" onclick="setDays(90)" class="px-3 py-1.5 text-xs font-medium rounded-full border border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
                                            Last 90 Days
                                        </button>
                                        <button type="button" onclick="setDays(365)" class="px-3 py-1.5 text-xs font-medium rounded-full border border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
                                            Last Year
                                        </button>
                                    </div>
                                </div>

                                <!-- Submit Button -->
                                <button 
                                    type="submit" 
                                    class="w-full flex items-center justify-center gap-3 px-6 py-3.5 bg-primary text-white rounded-lg font-semibold text-sm hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-all"
                                >
                                    <span class="material-symbols-outlined">download</span>
                                    Download Report as CSV
                                </button>
                            </form>
                        </div>

                        <!-- Footer Info -->
                        <div class="px-6 py-4 bg-slate-50 dark:bg-slate-800/30 border-t border-slate-200 dark:border-slate-800">
                            <div class="flex items-start gap-3">
                                <span class="material-symbols-outlined text-slate-400 text-lg">info</span>
                                <div class="text-xs text-slate-500 dark:text-slate-400">
                                    <p class="font-medium mb-1">Report Contents:</p>
                                    <p>Visitor ID, Name, Phone, Purpose, Check-in Date, Check-out Date, Admin ID</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Security Tips -->
                    <div class="mt-6 p-4 rounded-lg bg-slate-100 dark:bg-slate-800/50">
                        <div class="flex items-start gap-3">
                            <span class="material-symbols-outlined text-slate-500 text-lg">security</span>
                            <div class="text-xs text-slate-600 dark:text-slate-400">
                                <p class="font-semibold mb-1">Security Tips:</p>
                                <ul class="list-disc list-inside space-y-1">
                                    <li>Only your visitors are included in the report</li>
                                    <li>Reports are generated fresh each time (not cached)</li>
                                    <li>Keep downloaded reports in a secure location</li>
                                    <li>Delete old reports when no longer needed</li>
                                </ul>
                            </div>
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
            
            if (sidebar.classList.contains('-translate-x-full')) {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('hidden');
            } else {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('hidden');
            }
        }

        function setDays(days) {
            document.getElementById('days').value = days;
        }

        // Dark mode toggle (check system preference)
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.documentElement.classList.add('dark');
        }
    </script>
</body>
</html>
