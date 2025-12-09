package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import com.visitor.system.model.*;
import com.visitor.system.utils.OrganizationPurposeHelper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AddVisitorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // Get admin ID from session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        // Check if admin has set organization type
        AdminDAO adminDAO = new AdminDAO();
        String organizationType = adminDAO.getOrganizationType(adminId);
        
        if (organizationType == null || organizationType.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/settings?error=org_not_set");
            return;
        }

        // Get form parameters
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String purpose = req.getParameter("purpose");
        
        // Validate that the purpose is valid for this organization
        List<String> validPurposes = OrganizationPurposeHelper.getPurposesForOrganization(organizationType);
        if (!validPurposes.contains(purpose)) {
            res.sendRedirect(req.getContextPath() + "/pages/addVisitor.jsp?error=invalid_purpose");
            return;
        }

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