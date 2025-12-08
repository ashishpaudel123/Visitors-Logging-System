package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import com.visitor.system.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AddVisitorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // Get admin ID from session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        // Get form parameters
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String purpose = req.getParameter("purpose");

        // Create visitor with admin ID
        Visitor visitor = new Visitor(name, phone, purpose, adminId);

        // Add visitor to database
        VisitorDAO dao = new VisitorDAO();
        boolean success = dao.addVisitor(visitor, adminId);

        if (success) {
            res.sendRedirect(req.getContextPath() + "/pages/dashboard.jsp?success=1");
        } else {
            res.sendRedirect(req.getContextPath() + "/pages/addVisitor.jsp?error=1");
        }
    }
}