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

// Get only this admin's visitors
VisitorDAO dao = new VisitorDAO();
List<Visitor> recentVisitors = dao.getVisitorsByAdmin(adminId);
int totalVisitors = recentVisitors.size();
int todayVisitors = dao.getTodayVisitorCount(adminId);
int recentEntries = dao.getRecentEntriesCount(adminId);
List<Visitor> displayVisitors = recentVisitors.size() > 5 ? recentVisitors.subList(0, 5) : recentVisitors;
%>
<!DOCTYPE html>
<html class="light" lang="en">
      <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Visitor Entry Dashboard</title>
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
                <a class="flex items-center gap-3 px-3 py-2 rounded-lg bg-primary/10 text-primary" href="dashboard.jsp">
                  <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">dashboard</span>
                  <p class="text-sm font-semibold">Dashboard</p>
                </a>
                <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="addVisitor.jsp">
                  <span class="material-symbols-outlined">person_add</span>
                  <p class="text-sm font-medium">Add Visitor</p>
                </a>
                <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="../listVisitors">
                  <span class="material-symbols-outlined">list_alt</span>
                  <p class="text-sm font-medium">Visitor List</p>
                </a>
                <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="cleanLogs.jsp">
                  <span class="material-symbols-outlined">delete_sweep</span>
                  <p class="text-sm font-medium">Clean Old Logs</p>
                </a>
                <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="<%= request.getContextPath() %>/report">
                  <span class="material-symbols-outlined">download</span>
                  <p class="text-sm font-medium">Download Report</p>
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
                <h2 class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Visitor Entry System</h2>
              </div>
              <div class="flex flex-1 justify-end gap-4 items-center">
                <div class="relative">
                  <button onclick="toggleThemeMenu()" class="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800">
                    <span id="theme-icon" class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">light_mode</span>
                  </button>
                  <!-- Theme Menu -->
                  <div id="theme-menu" class="hidden absolute right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-lg shadow-lg border border-slate-200 dark:border-slate-700 py-2 z-50">
                    <button onclick="setTheme('light')" class="w-full px-4 py-2 text-left hover:bg-slate-100 dark:hover:bg-slate-700 flex items-center gap-3 text-slate-700 dark:text-slate-300">
                      <span class="material-symbols-outlined text-lg">light_mode</span>
                      <span class="text-sm font-medium">Light</span>
                      <span id="check-light" class="material-symbols-outlined text-primary ml-auto hidden" style="font-variation-settings: 'FILL' 1">check</span>
                    </button>
                    <button onclick="setTheme('dark')" class="w-full px-4 py-2 text-left hover:bg-slate-100 dark:hover:bg-slate-700 flex items-center gap-3 text-slate-700 dark:text-slate-300">
                      <span class="material-symbols-outlined text-lg">dark_mode</span>
                      <span class="text-sm font-medium">Dark</span>
                      <span id="check-dark" class="material-symbols-outlined text-primary ml-auto hidden" style="font-variation-settings: 'FILL' 1">check</span>
                    </button>
                    <button onclick="setTheme('system')" class="w-full px-4 py-2 text-left hover:bg-slate-100 dark:hover:bg-slate-700 flex items-center gap-3 text-slate-700 dark:text-slate-300">
                      <span class="material-symbols-outlined text-lg">computer</span>
                      <span class="text-sm font-medium">System</span>
                      <span id="check-system" class="material-symbols-outlined text-primary ml-auto hidden" style="font-variation-settings: 'FILL' 1">check</span>
                    </button>
                  </div>
                </div>
              </div>
            </header>

            <main class="flex-1 overflow-x-hidden overflow-y-auto bg-background-light dark:bg-background-dark p-8">
              <div class="max-w-7xl mx-auto">
                <!-- PageHeading -->
                <div class="flex flex-wrap justify-between items-center gap-4 mb-8">
                  <p class="text-slate-900 dark:text-white text-4xl font-black leading-tight tracking-[-0.033em]">Dashboard</p>
                  <a href="addVisitor.jsp" class="flex min-w-[84px] items-center justify-center rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] hover:bg-primary/90 transition-colors">
                    <span class="material-symbols-outlined mr-2 text-base">add</span>
                    <span class="truncate">Add New Visitor</span>
                  </a>
                </div>

                <!-- Stats -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                  <div class="flex flex-col gap-2 rounded-xl p-6 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40">
                    <p class="text-slate-600 dark:text-slate-300 text-base font-medium leading-normal">Total Visitors Today</p>
                    <p class="text-slate-900 dark:text-white tracking-tight text-3xl font-bold leading-tight"><%= todayVisitors %></p>
                  </div>
                  <div class="flex flex-col gap-2 rounded-xl p-6 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40">
                    <p class="text-slate-600 dark:text-slate-300 text-base font-medium leading-normal">Total Visitors</p>
                    <p class="text-slate-900 dark:text-white tracking-tight text-3xl font-bold leading-tight"><%= totalVisitors %></p>
                  </div>
                  <div class="flex flex-col gap-2 rounded-xl p-6 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40">
                    <p class="text-slate-600 dark:text-slate-300 text-base font-medium leading-normal">Recent Entries</p>
                    <p class="text-slate-900 dark:text-white tracking-tight text-3xl font-bold leading-tight"><%= recentEntries %></p>
                    <p class="text-slate-500 dark:text-slate-400 text-xs">Last 60 minutes</p>
                  </div>
                  <div class="flex flex-col gap-2 rounded-xl p-6 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40">
                    <p class="text-slate-600 dark:text-slate-300 text-base font-medium leading-normal">System Status</p>
                    <p class="text-green-600 dark:text-green-400 tracking-tight text-2xl font-bold leading-tight">Active</p>
                  </div>
                </div>

                <!-- Visitor Table -->
                <div class="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40 overflow-hidden">
                  <div class="px-6 py-4 border-b border-slate-200 dark:border-slate-800">
                    <h2 class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">Recent Visitors</h2>
                  </div>
                  <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left text-slate-500 dark:text-slate-400">
                      <thead class="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-800">
                        <tr>
                          <th class="px-6 py-3" scope="col">Name</th>
                          <th class="px-6 py-3" scope="col">Phone</th>
                          <th class="px-6 py-3" scope="col">Purpose</th>
                          <th class="px-6 py-3" scope="col">Check-in Time</th>
                        </tr>
                      </thead>
                      <tbody>
                        <% if (displayVisitors != null && !displayVisitors.isEmpty()) { for (Visitor visitor : displayVisitors) { %>
                        <tr class="bg-white dark:bg-transparent border-b dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50">
                          <th class="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" scope="row"><%= visitor.getName() %></th>
                          <td class="px-6 py-4"><%= visitor.getPhone() %></td>
                          <td class="px-6 py-4"><%= visitor.getPurpose() %></td>
                          <td class="px-6 py-4"><%= visitor.getCheckIn() %></td>
                        </tr>
                        <% } } else { %>
                        <tr class="bg-white dark:bg-transparent">
                          <td colspan="4" class="px-6 py-8 text-center text-slate-500 dark:text-slate-400">
                            <span class="material-symbols-outlined text-4xl mb-2">person_off</span>
                            <p>No visitors found</p>
                          </td>
                        </tr>
                        <% } %>
                      </tbody>
                    </table>
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

          // Theme Management
          function getThemePreference() {
            const stored = localStorage.getItem('theme');
            return stored || 'system';
          }

          function applyTheme(theme) {
            const html = document.documentElement;
            const themeIcon = document.getElementById('theme-icon');
            
            // Remove all checkmarks
            document.querySelectorAll('[id^="check-"]').forEach(el => el.classList.add('hidden'));
            
            if (theme === 'system') {
              const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
              html.classList.toggle('dark', prefersDark);
              if (themeIcon) {
                themeIcon.textContent = 'computer';
                themeIcon.style.color = '#3b82f6';
              }
              document.getElementById('check-system')?.classList.remove('hidden');
            } else if (theme === 'dark') {
              html.classList.add('dark');
              if (themeIcon) {
                themeIcon.textContent = 'dark_mode';
                themeIcon.style.color = '#fbbf24';
              }
              document.getElementById('check-dark')?.classList.remove('hidden');
            } else {
              html.classList.remove('dark');
              if (themeIcon) {
                themeIcon.textContent = 'light_mode';
                themeIcon.style.color = '#fbbf24';
              }
              document.getElementById('check-light')?.classList.remove('hidden');
            }
          }

          function setTheme(theme) {
            localStorage.setItem('theme', theme);
            applyTheme(theme);
            // Close menu
            document.getElementById('theme-menu')?.classList.add('hidden');
          }

          function toggleThemeMenu() {
            const menu = document.getElementById('theme-menu');
            if (menu) {
              menu.classList.toggle('hidden');
            }
          }

          // Initialize theme on load
          document.addEventListener('DOMContentLoaded', () => {
            const theme = getThemePreference();
            applyTheme(theme);
          });

          // Apply theme immediately (before DOMContentLoaded)
          applyTheme(getThemePreference());

          // Close menu when clicking outside
          document.addEventListener('click', (e) => {
            const menu = document.getElementById('theme-menu');
            const button = e.target.closest('button');
            if (menu && !menu.contains(e.target) && (!button || button.getAttribute('onclick') !== 'toggleThemeMenu()')) {
              menu.classList.add('hidden');
            }
          });

          // Listen for system theme changes
          window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
            if (getThemePreference() === 'system') {
              applyTheme('system');
            }
          });
        </script>
      </body>
    </html>
