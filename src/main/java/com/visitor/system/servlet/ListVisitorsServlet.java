package com.visitor.system.servlet;

import com.visitor.system.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ListVisitorsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        req.setAttribute("visitors", new VisitorDAO().getVisitors());
        req.getRequestDispatcher("/pages/visitors.jsp").forward(req, res);
    }
}