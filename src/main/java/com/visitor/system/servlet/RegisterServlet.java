package com.visitor.system.servlet;

import com.visitor.system.dao.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Forward to registration page
        req.getRequestDispatcher("/pages/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?error=required");
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?error=password");
            return;
        }

        // Check if username or email already exists
        AdminDAO adminDAO = new AdminDAO();
        boolean usernameExists = adminDAO.isUsernameExists(username);
        boolean emailExists = adminDAO.isEmailExists(email);

        if (usernameExists && emailExists) {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?error=both");
            return;
        } else if (usernameExists) {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?error=username");
            return;
        } else if (emailExists) {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?error=email");
            return;
        }

        // Create new admin
        boolean success = adminDAO.addAdmin(username, email, password);

        if (success) {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?success=true");
        } else {
            res.sendRedirect(req.getContextPath() + "/pages/register.jsp?error=failed");
        }
    }
}
