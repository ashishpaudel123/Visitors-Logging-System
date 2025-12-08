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

// Get only this admin's visitors
VisitorDAO dao = new VisitorDAO();
List<Visitor> visitors = dao.getVisitorsByAdmin(adminId);
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
    <body class="font-display bg-background-light dark:bg-background-dark text-[#0d121b] dark:text-gray-200">
      <div class="relative flex h-auto min-h-screen w-full flex-col group/design-root overflow-x-hidden">
        <div class="layout-container flex h-full grow flex-col">
          <header class="flex items-center justify-between whitespace-nowrap border-b border-solid border-[#e7ebf3] dark:border-gray-700 px-4 sm:px-6 lg:px-10 py-3 bg-background-light dark:bg-background-dark sticky top-0 z-10">
            <div class="flex items-center gap-4 text-[#0d121b] dark:text-white">
              <span class="material-symbols-outlined text-primary text-3xl">database</span>
              <h2 class="text-lg font-bold leading-tight tracking-[-0.015em]">Visitor Logging System</h2>
            </div>
            <div class="flex flex-1 justify-end gap-4 items-center">
              <a href="pages/addVisitor.jsp" class="flex min-w-[84px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold leading-normal tracking-[0.015em] gap-2 hover:bg-primary/90 transition-colors">
                <span class="material-symbols-outlined">add</span>
                <span class="truncate">Add Visitor</span>
              </a>
            </div>
          </header>

          <main class="px-4 sm:px-6 lg:px-10 flex flex-1 justify-center py-5">
            <div class="layout-content-container flex flex-col w-full max-w-7xl flex-1">
              <div class="flex flex-wrap justify-between items-center gap-4 py-4">
                <p class="text-[#0d121b] dark:text-white text-3xl font-black leading-tight tracking-[-0.033em]">Visitor List</p>
                <a href="pages/dashboard.jsp" class="flex h-9 shrink-0 items-center justify-center gap-x-2 rounded-lg bg-[#e7ebf3] dark:bg-gray-800/50 pl-4 pr-3 hover:bg-gray-300/60 dark:hover:bg-gray-700/60 transition-colors">
                  <span class="material-symbols-outlined text-lg">arrow_back</span>
                  <p class="text-sm font-medium leading-normal">Back to Dashboard</p>
                </a>
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
    </body>
  </html>
</Visitor>
