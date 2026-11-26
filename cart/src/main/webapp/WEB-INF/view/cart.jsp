<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Giao dien JSTL + EL (Ch8 Ex 8-1, Ch9). Khong dung scripting. --%>
<c:url var="stylesUrl" value="/css/style.css" />
<c:url var="cartUrl" value="/cart" />
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="${stylesUrl}">
</head>

<body>
    <h2>Your cart</h2>

    <%-- Ch8: implicit object param --%>
    <c:if test="${param.action == 'checkout'}">
        <p class="msg">Thank you for your order!</p>
    </c:if>

    <c:choose>
        <c:when test="${empty sessionScope.cart.items}">
            <p>Your cart is empty.</p>
        </c:when>
        <c:otherwise>
            <p>You have <c:out value="${sessionScope.cart.count}" />
                ${sessionScope.cart.count == 1 ? 'product' : 'products'}
                (<c:out value="${sessionScope.cart.totalQuantity}" />
                ${sessionScope.cart.totalQuantity == 1 ? 'item' : 'items'}) in your cart.</p>

            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Quantity</th>
                        <th>Description</th>
                        <th class="right">Price</th>
                        <th class="right">Amount</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="lineItem" items="${sessionScope.cart.items}" varStatus="status">
                        <tr class="${status.index % 2 == 0 ? 'even' : 'odd'}">
                            <td><c:out value="${status.count}" /></td>
                            <td>
                                <form action="${cartUrl}" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productCode"
                                        value="<c:out value='${lineItem.product.code}' />">
                                    <input type="number" name="quantity"
                                        value="<c:out value='${lineItem.quantity}' />" min="0" required>
                                    <input type="submit" value="Update">
                                </form>
                            </td>
                            <td><c:out value="${lineItem.product.description}" /></td>
                            <td class="right"><c:out value="${lineItem.product.priceCurrencyFormat}" /></td>
                            <td class="right"><c:out value="${lineItem.totalCurrencyFormat}" /></td>
                            <td>
                                <form action="${cartUrl}" method="post">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productCode"
                                        value="<c:out value='${lineItem.product.code}' />">
                                    <input type="submit" value="Remove Item">
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" class="right"><b>Total</b></td>
                        <td class="right"><b><c:out value="${sessionScope.cart.totalCurrencyFormat}" /></b></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>

            <p><b>To change the quantity</b>, enter the new quantity and click on the Update button.</p>
        </c:otherwise>
    </c:choose>

    <section class="actions">
        <form action="${cartUrl}" method="post">
            <input type="hidden" name="action" value="shop">
            <input type="submit" value="Continue Shopping">
        </form><br>
        <c:if test="${not empty sessionScope.cart.items}">
            <form action="${cartUrl}" method="post">
                <input type="hidden" name="action" value="checkout">
                <input type="submit" value="Checkout">
            </form>
        </c:if>
    </section>

    <%-- Ex 8-1 (buoc 7, 9): ngay hien tai, 2 phan tu dau cua list, init parameter; scope tuong minh --%>
    <footer>
        <div>Today: <c:out value="${requestScope.currentDate}" /></div>
        <c:if test="${not empty sessionScope.cart.items}">
            <div>First items:
                <c:out value="${sessionScope.cart.items[0].product.description}" />
                <c:if test="${sessionScope.cart.count > 1}">
                    | <c:out value="${sessionScope.cart.items[1].product.description}" />
                </c:if>
            </div>
        </c:if>
        <div>Customer service:
            <a href="mailto:<c:out value='${initParam.custServEmail}' />"><c:out value="${initParam.custServEmail}" /></a>
        </div>
    </footer>
</body>

</html>
