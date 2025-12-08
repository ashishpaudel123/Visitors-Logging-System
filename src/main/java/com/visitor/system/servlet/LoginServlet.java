package com.visitor.system.servlet;

import com.visitor.system.dao.AdminDAO;
import com.visitor.system.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            res.sendRedirect(req.getContextPath() + "/pages/dashboard.jsp");
            return;
        }

        // Forward to login page
        req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/pages/login.jsp?error=required");
            return;
        }

        // Authenticate admin
        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.authenticateAdmin(username, password);

        if (admin != null) {
            // Create session
            HttpSession session = req.getSession();
            session.setAttribute("adminId", admin.getId());
            session.setAttribute("adminUsername", admin.getUsername());
            session.setAttribute("adminEmail", admin.getEmail());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect to dashboard
            res.sendRedirect(req.getContextPath() + "/pages/dashboard.jsp");
        } else {
            // Authentication failed
            res.sendRedirect(req.getContextPath() + "/pages/login.jsp?error=invalid");
        }
    }
}
