<%@ page import="java.util.List" %>
<%@ page import="com.visitor.system.model.Visitor" %>
<%@ page import="com.visitor.system.dao.VisitorDAO" %>
<%
// Security check - get admin ID from session
Integer adminId = (Integer) session.getAttribute("adminId");
if (adminId == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// Get attributes from servlet
List<Visitor> visitors = (List<Visitor>) request.getAttribute("visitors");
List<String> purposes = (List<String>) request.getAttribute("purposes");
String organizationType = (String) request.getAttribute("organizationType");
String searchTerm = (String) request.getAttribute("searchTerm");
String purposeFilter = (String) request.getAttribute("purposeFilter");

// Set defaults if null
if (searchTerm == null) searchTerm = "";
if (purposeFilter == null) purposeFilter = "all";

int serialNumber = 1;
%>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
      <meta charset="utf-8" />
      <meta content="width=device-width, initial-scale=1.0" name="viewport" />
      <title>Visitor List</title>
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
        tr:hover .action-icons {
          opacity: 1;
        }
      </style>
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
              <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="pages/dashboard.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                <p class="text-sm font-medium">Dashboard</p>
              </a>
              <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="pages/addVisitor.jsp">
                <span class="material-symbols-outlined">person_add</span>
                <p class="text-sm font-medium">Add Visitor</p>
              </a>
              <a class="flex items-center gap-3 px-3 py-2 rounded-lg bg-primary/10 text-primary" href="<%= request.getContextPath() %>/listVisitors">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1">list_alt</span>
                <p class="text-sm font-semibold">Visitor List</p>
              </a>
              <a class="flex items-center gap-3 px-3 py-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800" href="pages/cleanLogs.jsp">
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
          <!-- Mobile Header -->
          <header class="h-16 flex lg:hidden items-center justify-between border-b border-slate-200 dark:border-slate-800 px-4 bg-white dark:bg-background-dark">
            <button onclick="toggleSidebar()" class="p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800">
              <span class="material-symbols-outlined">menu</span>
            </button>
            <h2 class="text-slate-900 dark:text-white text-lg font-bold">Visitor List</h2>
            <div class="w-10"></div>
          </header>
          <main class="flex-1 overflow-x-hidden overflow-y-auto bg-background-light dark:bg-background-dark p-4 lg:p-8">
            <div class="layout-content-container flex flex-col w-full max-w-7xl flex-1">
              <div class="flex flex-wrap justify-between items-center gap-4 py-4">
                <p class="text-[#0d121b] dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Visitor List</p>
              </div>

              <!-- Search and Filter Section -->
              <div class="bg-white dark:bg-slate-900/40 rounded-xl border border-slate-200 dark:border-slate-800 p-6 mb-6">
                <form method="GET" action="<%= request.getContextPath() %>/listVisitors" class="flex flex-col gap-4">
                  <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <!-- Search Input -->
                    <div class="flex flex-col gap-2">
                      <label for="search" class="text-sm font-medium text-slate-700 dark:text-slate-300">
                        <span class="material-symbols-outlined text-lg align-middle mr-1">search</span>
                        Search by Name or Phone
                      </label>
                      <input 
                        type="text" 
                        id="search" 
                        name="search" 
                        value="<%= searchTerm %>"
                        placeholder="Enter name or phone..." 
                        class="form-input w-full h-11 rounded-lg border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 focus:border-primary px-4">
                    </div>

                    <!-- Purpose Filter -->
                    <div class="flex flex-col gap-2">
                      <label for="purpose" class="text-sm font-medium text-slate-700 dark:text-slate-300">
                        <span class="material-symbols-outlined text-lg align-middle mr-1">filter_list</span>
                        Filter by Purpose
                      </label>
                      <% if (organizationType != null && purposes != null) { %>
                      <select 
                        id="purpose" 
                        name="purpose" 
                        class="form-select w-full h-11 rounded-lg border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 focus:border-primary px-4">
                        <option value="all" <%= "all".equals(purposeFilter) ? "selected" : "" %>>All Purposes</option>
                        <% for (String purpose : purposes) { %>
                        <option value="<%= purpose %>" <%= purpose.equals(purposeFilter) ? "selected" : "" %>><%= purpose %></option>
                        <% } %>
                      </select>
                      <% } else { %>
                      <select disabled class="form-select w-full h-11 rounded-lg border border-slate-300 dark:border-slate-600 bg-slate-100 dark:bg-slate-700 text-slate-400 px-4 cursor-not-allowed">
                        <option>Set organization type first</option>
                      </select>
                      <% } %>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex flex-col gap-2 justify-end">
                      <div class="flex gap-2">
                        <button 
                          type="submit" 
                          class="flex-1 flex items-center justify-center gap-2 h-11 bg-primary text-white font-medium rounded-lg hover:bg-primary/90 transition-colors focus:outline-none focus:ring-2 focus:ring-primary/50">
                          <span class="material-symbols-outlined text-lg">search</span>
                          Search
                        </button>
                        <a 
                          href="<%= request.getContextPath() %>/listVisitors" 
                          class="flex items-center justify-center gap-2 h-11 px-4 bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-300 font-medium rounded-lg hover:bg-slate-300 dark:hover:bg-slate-600 transition-colors">
                          <span class="material-symbols-outlined text-lg">refresh</span>
                          Reset
                        </a>
                      </div>
                    </div>
                  </div>

                  <!-- Active Filters Display -->
                  <% if (!searchTerm.isEmpty() || !"all".equals(purposeFilter)) { %>
                  <div class="flex items-center gap-2 pt-2 border-t border-slate-200 dark:border-slate-700">
                    <span class="text-sm text-slate-600 dark:text-slate-400">Active filters:</span>
                    <% if (!searchTerm.isEmpty()) { %>
                    <span class="inline-flex items-center gap-1 px-3 py-1 bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 rounded-full text-sm">
                      <span class="material-symbols-outlined text-base">search</span>
                      "<%= searchTerm %>"
                    </span>
                    <% } %>
                    <% if (!"all".equals(purposeFilter)) { %>
                    <span class="inline-flex items-center gap-1 px-3 py-1 bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-300 rounded-full text-sm">
                      <span class="material-symbols-outlined text-base">category</span>
                      <%= purposeFilter %>
                    </span>
                    <% } %>
                  </div>
                  <% } %>
                </form>
              </div>

              <!-- Results Count -->
              <div class="mb-4">
                <p class="text-sm text-slate-600 dark:text-slate-400">
                  Showing <strong><%= visitors != null ? visitors.size() : 0 %></strong> visitor(s)
                  <% if (!searchTerm.isEmpty() || !"all".equals(purposeFilter)) { %>
                  matching your filters
                  <% } %>
                </p>
              </div>

              <% if (visitors != null && !visitors.isEmpty()) { %>
              <div class="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40 overflow-hidden">
                <div class="overflow-x-auto">
                  <table class="w-full text-sm text-left text-slate-500 dark:text-slate-400">
                    <thead class="text-xs text-slate-700 dark:text-slate-300 uppercase bg-slate-50 dark:bg-slate-800">
                      <tr>
                        <th class="px-6 py-3" scope="col">S.N.</th>
                        <th class="px-6 py-3" scope="col">Name</th>
                        <th class="px-6 py-3" scope="col">Phone</th>
                        <th class="px-6 py-3" scope="col">Purpose</th>
                        <th class="px-6 py-3" scope="col">Check-in Time</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% for (Visitor visitor : visitors) { %>
                      <tr class="bg-white dark:bg-transparent border-b dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50">
                        <td class="px-6 py-4"><%= serialNumber++ %></td>
                        <th class="px-6 py-4 font-medium text-slate-900 dark:text-white whitespace-nowrap" scope="row"><%= visitor.getName() %></th>
                        <td class="px-6 py-4"><%= visitor.getPhone() %></td>
                        <td class="px-6 py-4"><%= visitor.getPurpose() %></td>
                        <td class="px-6 py-4"><%= visitor.getCheckIn() %></td>
                      </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              </div>
              <% } else { %>
              <div class="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900/40 overflow-hidden">
                <div class="px-6 py-8 text-center text-slate-500 dark:text-slate-400">
                  <span class="material-symbols-outlined text-4xl mb-2">person_off</span>
                  <p>No visitors found</p>
                </div>
              </div>
              <% } %>
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
