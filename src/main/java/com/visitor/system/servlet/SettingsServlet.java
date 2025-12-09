package com.visitor.system.servlet;

import com.visitor.system.dao.AdminDAO;
import com.visitor.system.utils.OrganizationPurposeHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("pages/login.jsp");
            return;
        }

        int adminId = (int) session.getAttribute("adminId");
        
        // Get current organization type
        String currentOrgType = adminDAO.getOrganizationType(adminId);
        request.setAttribute("currentOrgType", currentOrgType);
        
        // Forward to settings page
        request.getRequestDispatcher("/pages/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("pages/login.jsp");
            return;
        }

        int adminId = (int) session.getAttribute("adminId");
        String organizationType = request.getParameter("organizationType");

        // Validate organization type
        if (organizationType == null || organizationType.trim().isEmpty()) {
            request.setAttribute("error", "Please select an organization type");
            request.setAttribute("currentOrgType", adminDAO.getOrganizationType(adminId));
            request.getRequestDispatcher("/pages/settings.jsp").forward(request, response);
            return;
        }

        if (!OrganizationPurposeHelper.isValidOrganizationType(organizationType)) {
            request.setAttribute("error", "Invalid organization type selected");
            request.setAttribute("currentOrgType", adminDAO.getOrganizationType(adminId));
            request.getRequestDispatcher("/pages/settings.jsp").forward(request, response);
            return;
        }

        // Update organization type
        boolean success = adminDAO.updateOrganizationType(adminId, organizationType);
        
        if (success) {
            // Store in session for quick access
            session.setAttribute("organizationType", organizationType);
            request.setAttribute("success", "Organization type updated successfully!");
            request.setAttribute("currentOrgType", organizationType);
        } else {
            request.setAttribute("error", "Failed to update organization type. Please try again.");
            request.setAttribute("currentOrgType", adminDAO.getOrganizationType(adminId));
        }

        request.getRequestDispatcher("/pages/settings.jsp").forward(request, response);
    }
}
