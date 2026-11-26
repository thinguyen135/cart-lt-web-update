# cart_lt_wed

```bash
docker build -t cart_lt_wed .
docker run -p 8080:8080 cart_lt_wed
```



## Bài tập Chapter 8 / 9 áp dụng vào Cart

| Bài | Nội dung | Áp dụng trong cart |
|---|---|---|
| Ex 8-1 | EL: `initParam`, scope tường minh, phần tử đầu của collection, `empty`, `?:`, `param` | `web.xml` (`custServEmail`), `CartServlet` (request attr `currentDate`), footer + thông báo trong `home.jsp` / `cart.jsp`; `scripting-invalid` bật trong `web.xml` |
| Ex 9-1 | JSTL: `c:out` escape mọi giá trị, `c:if` theo cookie | Cookie `lastProduct` (set khi Add To Cart) → `c:if` trong `home.jsp` |
| Ex 9-2 | `c:forEach` qua list Product, `c:out` chống XSS | `home.jsp`, `cart.jsp` (thêm `varStatus`, `c:url`, `c:param`) |
