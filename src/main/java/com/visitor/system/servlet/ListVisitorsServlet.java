package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ListVisitorsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Get admin ID from session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        // Get only this admin's visitors
        VisitorDAO dao = new VisitorDAO();
        req.setAttribute("visitors", dao.getVisitorsByAdmin(adminId));
        req.getRequestDispatcher("/pages/visitors.jsp").forward(req, res);
    }
}