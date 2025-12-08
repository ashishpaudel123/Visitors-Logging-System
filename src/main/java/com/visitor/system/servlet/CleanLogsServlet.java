package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CleanLogsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // Get admin ID from session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        // Get days parameter
        String daysParam = req.getParameter("days");
        int days = 30; // default

        try {
            if (daysParam != null && !daysParam.isEmpty()) {
                days = Integer.parseInt(daysParam);
            }
        } catch (NumberFormatException e) {
            days = 30;
        }

        // Delete only this admin's old visitors
        VisitorDAO dao = new VisitorDAO();
        int deletedCount = dao.deleteOldVisitors(days, adminId);

        res.sendRedirect(
                req.getContextPath() + "/pages/cleanLogs.jsp?cleaned=1&days=" + days + "&count=" + deletedCount);
    }
}