-- 月次売り上げ集計
SELECT
    DATE_TRUNC('month', t_order.created_at) AS month,
    SUM(t_payment.billing_amount) AS billing_amount 
FROM 
    t_order
JOIN 
    t_payment ON t_order.id = t_payment.order_id
GROUP BY 
    DATE_TRUNC('month', t_order.created_at)
ORDER BY 
    month DESC;

-- 未払の注文
SELECT 
    t_order.id AS order_id,
    t_order.customer_name,
    t_order.phone_number,
    t_payment.billing_amount AS billing_amount,
    t_payment.received_amount AS received_amount
FROM 
    t_order
LEFT JOIN 
    t_payment ON t_order.id = t_payment.order_id
WHERE
    t_payment.paid_at is NULL 
ORDER BY 
    t_order.created_at DESC;

-- 人気な寿司ランキング
SELECT 
    m_menu.name AS menu_name,
    SUM(t_order_item.quantity) AS order_count
FROM 
    t_order_item
JOIN 
    m_menu ON t_order_item.menu_id = m_menu.id
GROUP BY 
    m_menu.name
ORDER BY 
    order_count DESC
LIMIT 10;
