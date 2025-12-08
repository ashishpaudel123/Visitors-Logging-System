package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import com.visitor.system.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AddVisitorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        VisitorDAO dao = new VisitorDAO();
        dao.addVisitor(new Visitor(req.getParameter("name"), req.getParameter("phone"), req.getParameter("purpose")));
        res.sendRedirect("pages/dashboard.jsp?success=1");
    }
}