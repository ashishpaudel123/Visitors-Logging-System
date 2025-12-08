<!DOCTYPE html>
<html class="light" lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Add New Visitor</title>
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
  </head>
  <body class="font-display">
    <div
      class="relative flex h-auto min-h-screen w-full flex-col bg-background-light dark:bg-background-dark group/design-root overflow-x-hidden"
    >
      <div class="layout-container flex h-full grow flex-col">
        <header
          class="flex items-center justify-between whitespace-nowrap border-b border-solid border-b-slate-200 dark:border-b-slate-700 px-4 sm:px-6 lg:px-10 py-3"
        >
          <div class="flex items-center gap-4 text-slate-900 dark:text-white">
            <span class="material-symbols-outlined text-primary text-2xl"
              >qr_code_scanner</span
            >
            <h2
              class="text-slate-900 dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]"
            >
              Visitor Entry System
            </h2>
          </div>
          <div class="flex flex-1 justify-end gap-2 sm:gap-4">
            <a
              href="dashboard.jsp"
              class="flex max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 bg-slate-200/60 dark:bg-slate-700/60 text-slate-900 dark:text-white gap-2 text-sm font-bold leading-normal tracking-[0.015em] min-w-0 px-2.5"
            >
              <span class="material-symbols-outlined">home</span>
            </a>
            <div
              class="bg-primary/10 rounded-full size-10 flex items-center justify-center"
            >
              <span class="material-symbols-outlined text-primary">person</span>
            </div>
          </div>
        </header>

        <main
          class="px-4 sm:px-6 lg:px-8 flex flex-1 justify-center py-8 sm:py-12"
        >
          <div
            class="layout-content-container flex flex-col w-full max-w-2xl flex-1"
          >
            <div class="flex flex-wrap justify-between gap-3 p-4">
              <p
                class="text-slate-900 dark:text-white text-3xl sm:text-4xl font-black leading-tight tracking-[-0.033em] min-w-72"
              >
                Add New Visitor
              </p>
            </div>

            <div
              class="bg-white dark:bg-slate-800/50 p-6 sm:p-8 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700/50 mt-4"
            >
              <form
                method="post"
                action="../addVisitor"
                class="flex flex-col gap-6"
              >
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <label class="flex flex-col flex-1">
                    <p
                      class="text-slate-800 dark:text-slate-200 text-sm font-medium leading-normal pb-2"
                    >
                      Full Name
                    </p>
                    <div class="flex w-full flex-1 items-stretch rounded-lg">
                      <input
                        name="name"
                        required
                        class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark focus:border-primary h-12 placeholder:text-slate-400 p-[15px] rounded-r-none border-r-0 pr-2 text-base font-normal leading-normal"
                        placeholder="John Doe"
                      />
                      <div
                        class="text-slate-400 flex border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark items-center justify-center pr-[15px] rounded-r-lg border-l-0"
                      >
                        <span class="material-symbols-outlined text-lg"
                          >person</span
                        >
                      </div>
                    </div>
                  </label>

                  <label class="flex flex-col flex-1">
                    <p
                      class="text-slate-800 dark:text-slate-200 text-sm font-medium leading-normal pb-2"
                    >
                      Phone Number
                    </p>
                    <div class="flex w-full flex-1 items-stretch rounded-lg">
                      <input
                        name="phone"
                        required
                        class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark focus:border-primary h-12 placeholder:text-slate-400 p-[15px] rounded-r-none border-r-0 pr-2 text-base font-normal leading-normal"
                        placeholder="+1 (555) 000-0000"
                      />
                      <div
                        class="text-slate-400 flex border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark items-center justify-center pr-[15px] rounded-r-lg border-l-0"
                      >
                        <span class="material-symbols-outlined text-lg"
                          >phone</span
                        >
                      </div>
                    </div>
                  </label>
                </div>

                <div>
                  <h2
                    class="text-slate-800 dark:text-slate-200 text-sm font-medium leading-tight pb-2 pt-2"
                  >
                    Purpose of Visit
                  </h2>
                  <div class="flex w-full flex-1 items-stretch rounded-lg mt-1">
                    <input
                      name="purpose"
                      required
                      class="form-input flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-slate-900 dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark focus:border-primary h-12 placeholder:text-slate-400 p-[15px] rounded-r-none border-r-0 pr-2 text-base font-normal leading-normal"
                      placeholder="e.g. Meeting with Jane Smith"
                    />
                    <div
                      class="text-slate-400 flex border border-slate-300 dark:border-slate-600 bg-background-light dark:bg-background-dark items-center justify-center pr-[15px] rounded-r-lg border-l-0"
                    >
                      <span class="material-symbols-outlined text-lg"
                        >edit_note</span
                      >
                    </div>
                  </div>
                </div>

                <div
                  class="flex flex-col sm:flex-row-reverse items-center gap-3 border-t border-slate-200 dark:border-slate-700 pt-6 mt-4"
                >
                  <button
                    type="submit"
                    class="flex w-full sm:w-auto cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 bg-primary text-white gap-2 text-base font-bold leading-normal tracking-[0.015em] min-w-0 px-6 hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary/50 dark:focus:ring-offset-background-dark transition-colors duration-150"
                  >
                    Save Visitor
                  </button>
                  <a
                    href="dashboard.jsp"
                    class="flex w-full sm:w-auto cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 bg-transparent text-slate-600 dark:text-slate-300 gap-2 text-base font-bold leading-normal tracking-[0.015em] min-w-0 px-6 hover:bg-slate-100 dark:hover:bg-slate-700/50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500/50 dark:focus:ring-offset-background-dark transition-colors duration-150"
                  >
                    Cancel
                  </a>
                </div>
              </form>
            </div>
          </div>
        </main>
      </div>
    </div>
  </body>
</html>
