package com.example.cart.controller;

import com.example.cart.BEAN.Cart;
import com.example.cart.BEAN.Product;
import com.example.cart.DAO.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;

@WebServlet(name = "CartServlet", urlPatterns = { "/cart" })
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "shop";
        }

        HttpSession session = request.getSession();

        final Object lock = session.getId().intern();
        Cart cart;
        synchronized (lock) {
            cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }
        }

        // perform action and pick the page to show
        String page = "home";
        String productCode = request.getParameter("productCode");

        synchronized (lock) {
            if (action.equals("shop")) {
                page = "home";

            } else if (action.equals("add")) {
                Product product = ProductDAO.getProduct(productCode);
                cart.addItem(product, 1);
                page = "cart";

            } else if (action.equals("update")) {
                int quantity;
                try {
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                } catch (NumberFormatException e) {
                    quantity = 1;
                }
                cart.updateItem(productCode, quantity);
                page = "cart";

            } else if (action.equals("remove")) {
                cart.removeItem(productCode);
                page = "cart";

            } else if (action.equals("checkout")) {
                session.removeAttribute("cart");
                page = "cart";

            } else if (action.equals("cart")) {
                page = "cart";
            }
        }

        if (page.equals("home")) {
            request.setAttribute("products", ProductDAO.getProducts());
        }

        // Ch8 (Ex 8-1): ngay hien tai la request attribute -> ${requestScope.currentDate}
        request.setAttribute("currentDate", new Date());

        // forward to the view
        String url = "/WEB-INF/view/" + page + ".jsp";
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }
}
