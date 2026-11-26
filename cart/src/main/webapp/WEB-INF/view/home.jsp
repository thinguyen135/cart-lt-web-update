<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Giao dien JSTL + EL (Ch8 Ex 8-1, Ch9 Ex 9-1 / 9-2). Khong dung scripting. --%>
<c:url var="stylesUrl" value="/css/style.css" />
<c:url var="cartUrl" value="/cart" />
<c:url var="viewCartUrl" value="/cart">
    <c:param name="action" value="cart" />
</c:url>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mua hàng</title>
    <link rel="stylesheet" href="${stylesUrl}">
</head>

<body>
    <h2>CD list</h2>

    <%-- Ex 9-1 (buoc 6): chi hien loi chao neu cookie khac null --%>
    <c:if test="${not empty cookie.lastProduct}">
        <p class="msg">Welcome back! Last CD you added to your cart:
            <b><c:out value="${cookie.lastProduct.value}" /></b></p>
    </c:if>

    <%-- Ch8: scope tuong minh + empty + toan tu ba ngoi --%>
    <c:if test="${not empty sessionScope.cart.items}">
        <p>Your cart has <c:out value="${sessionScope.cart.totalQuantity}" />
            ${sessionScope.cart.totalQuantity == 1 ? 'item' : 'items'}
            (<c:out value="${sessionScope.cart.totalCurrencyFormat}" />) -
            <a href="${viewCartUrl}">View cart</a></p>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Description</th>
                <th class="right">Price</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <%-- Ex 9-2: forEach qua danh sach Product, c:out de chong XSS --%>
            <c:forEach var="product" items="${requestScope.products}" varStatus="status">
                <tr class="${status.index % 2 == 0 ? 'even' : 'odd'}">
                    <td><c:out value="${status.count}" /></td>
                    <td><c:out value="${product.description}" /></td>
                    <td class="right"><c:out value="${product.priceCurrencyFormat}" /></td>
                    <td>
                        <form action="${cartUrl}" method="post">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productCode" value="<c:out value='${product.code}' />">
                            <input type="submit" value="Add To Cart">
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <%-- Ex 8-1 (buoc 7): ngay hien tai, 2 phan tu dau cua collection, init parameter --%>
    <footer>
        <div>Today: <c:out value="${requestScope.currentDate}" /></div>
        <div>Featured:
            <c:out value="${requestScope.products[0].description}" />
            <c:if test="${not empty requestScope.products[1]}">
                | <c:out value="${requestScope.products[1].description}" />
            </c:if>
        </div>
        <div>Customer service:
            <a href="mailto:<c:out value='${initParam.custServEmail}' />"><c:out value="${initParam.custServEmail}" /></a>
        </div>
    </footer>
</body>

</html>
