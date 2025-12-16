package com.visitor.system.servlet;

import com.visitor.system.dao.AdminDAO;
import com.visitor.system.dao.VisitorDAO;
import com.visitor.system.model.Admin;
import com.visitor.system.model.Visitor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * ReportServlet - Handles secure visitor report generation and CSV download
 * 
 * Security Features:
 * - Session-based authentication (must be logged in)
 * - Password re-verification before accessing sensitive data
 * - Prepared statements to prevent SQL injection
 * - No password exposure in frontend
 */
@WebServlet("/report")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Forward to report page
        req.getRequestDispatcher("/pages/report.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Integer adminId = (Integer) session.getAttribute("adminId");
        String password = req.getParameter("password");
        String daysStr = req.getParameter("days");

        // Validate inputs
        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Password is required for security verification.");
            req.getRequestDispatcher("/pages/report.jsp").forward(req, res);
            return;
        }

        if (daysStr == null || daysStr.trim().isEmpty()) {
            req.setAttribute("error", "Please enter the number of days for the report.");
            req.getRequestDispatcher("/pages/report.jsp").forward(req, res);
            return;
        }

        int days;
        try {
            days = Integer.parseInt(daysStr.trim());
            if (days <= 0 || days > 365) {
                req.setAttribute("error", "Days must be between 1 and 365.");
                req.getRequestDispatcher("/pages/report.jsp").forward(req, res);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid number of days. Please enter a valid number.");
            req.getRequestDispatcher("/pages/report.jsp").forward(req, res);
            return;
        }

        // Verify admin password
        AdminDAO adminDAO = new AdminDAO();
        if (!adminDAO.verifyPassword(adminId, password)) {
            req.setAttribute("error", "Incorrect password. Access denied.");
            req.getRequestDispatcher("/pages/report.jsp").forward(req, res);
            return;
        }

        // Password verified - fetch visitor data
        VisitorDAO visitorDAO = new VisitorDAO();
        List<Visitor> visitors = visitorDAO.getVisitorsByAdminAndDays(adminId, days);

        // Generate CSV
        generateCSV(res, visitors, days, adminId);
    }

    /**
     * Generates and streams a CSV file to the client
     * 
     * @param res      HttpServletResponse to write CSV to
     * @param visitors List of visitors to include in report
     * @param days     Number of days for the report (for filename)
     * @param adminId  Admin ID (optional column in CSV)
     */
    private void generateCSV(HttpServletResponse res, List<Visitor> visitors, int days, int adminId)
            throws IOException {
        // Set response headers for CSV download
        res.setContentType("text/csv; charset=UTF-8");
        res.setCharacterEncoding("UTF-8");
        String filename = "visitor_report_last_" + days + "_days.csv";
        res.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        // Write UTF-8 BOM for Excel compatibility
        res.getOutputStream().write(0xEF);
        res.getOutputStream().write(0xBB);
        res.getOutputStream().write(0xBF);

        PrintWriter writer = new PrintWriter(res.getOutputStream(), true, StandardCharsets.UTF_8);

        // Write CSV header
        writer.println("Visitor ID,Visitor Name,Phone Number,Purpose,Check-in Date,Check-out Date,Admin ID");

        // Write visitor data
        for (Visitor visitor : visitors) {
            StringBuilder row = new StringBuilder();
            row.append(visitor.getId()).append(",");
            row.append(escapeCSV(visitor.getName())).append(",");
            row.append(escapeCSV(visitor.getPhone())).append(",");
            row.append(escapeCSV(visitor.getPurpose())).append(",");
            row.append(escapeCSV(visitor.getCheckIn())).append(",");
            row.append(escapeCSV(visitor.getCheckOut() != null ? visitor.getCheckOut() : "N/A")).append(",");
            row.append(visitor.getAdminId());
            writer.println(row.toString());
        }

        writer.flush();
        writer.close();
    }

    /**
     * Escapes a string for CSV format
     * - Wraps in quotes if contains comma, newline, or quotes
     * - Escapes internal quotes by doubling them
     * 
     * @param value The string to escape
     * @return Properly escaped CSV string
     */
    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }

        // Check if escaping is needed
        boolean needsEscape = value.contains(",") || value.contains("\"") ||
                value.contains("\n") || value.contains("\r");

        if (needsEscape) {
            // Escape quotes by doubling them and wrap in quotes
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }

        return value;
    }
}
