package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import com.visitor.system.utils.OrganizationPurposeHelper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ListVisitorsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        // Get admin ID from session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");
        
        // Get search and filter parameters
        String searchTerm = req.getParameter("search");
        String purposeFilter = req.getParameter("purpose");
        
        // Get admin's organization type for purpose list
        AdminDAO adminDAO = new AdminDAO();
        String organizationType = adminDAO.getOrganizationType(adminId);
        List<String> purposes = null;
        if (organizationType != null && !organizationType.isEmpty()) {
            purposes = OrganizationPurposeHelper.getPurposesForOrganization(organizationType);
        }
        
        // Get filtered visitors
        VisitorDAO dao = new VisitorDAO();
        List<com.visitor.system.model.Visitor> visitors;
        if ((searchTerm != null && !searchTerm.trim().isEmpty()) || 
            (purposeFilter != null && !purposeFilter.trim().isEmpty() && !"all".equals(purposeFilter))) {
            visitors = dao.getFilteredVisitors(adminId, searchTerm, purposeFilter);
        } else {
            visitors = dao.getVisitorsByAdmin(adminId);
        }
        
        // Set attributes for JSP
        req.setAttribute("visitors", visitors);
        req.setAttribute("purposes", purposes);
        req.setAttribute("organizationType", organizationType);
        req.setAttribute("searchTerm", searchTerm != null ? searchTerm : "");
        req.setAttribute("purposeFilter", purposeFilter != null ? purposeFilter : "all");
        
        req.getRequestDispatcher("/pages/visitors.jsp").forward(req, res);
    }
}