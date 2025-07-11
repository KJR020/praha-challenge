.PHONY: connect-admin connect-praha connect-tokyo connect-osaka test-rls

# データベース接続
connect-admin:
	docker exec -it src-db-1 psql -U postgres -d postgres

connect-praha:
	docker exec -it src-db-1 psql -U praha_user -d postgres

connect-tokyo:
	docker exec -it src-db-1 psql -U tokyo_user -d postgres

connect-osaka:
	docker exec -it src-db-1 psql -U osaka_user -d postgres

# RLSテスト
test-rls:
	@echo "=== Testing RLS (Row Level Security) ==="
	@echo ""
	@echo "1. Admin user - should see all data:"
	@docker exec -it src-db-1 psql -U postgres -d postgres -c "SELECT 'Admin View' as user_type, * FROM employees;"
	@echo ""
	@echo "2. Praha user - should see only praha tenant data:"
	@docker exec -it src-db-1 psql -U praha_user -d postgres -c "SELECT 'Praha User View' as user_type, * FROM employees;"
	@echo ""
	@echo "3. Tokyo user - should see only tokyo tenant data:"
	@docker exec -it src-db-1 psql -U tokyo_user -d postgres -c "SELECT 'Tokyo User View' as user_type, * FROM employees;"
	@echo ""
	@echo "4. Osaka user - should see only osaka tenant data:"
	@docker exec -it src-db-1 psql -U osaka_user -d postgres -c "SELECT 'Osaka User View' as user_type, * FROM employees;"

# クエリテスト
test-queries:
	@echo "=== Running test queries ==="
	@echo ""
	@echo "Testing JOIN queries with Praha user:"
	@docker exec -it src-db-1 psql -U praha_user -d postgres -c "SELECT e.name as employee_name, p.name as project_name FROM employees e JOIN projects p ON e.tenant_id = p.tenant_id;"
	@echo ""
	@echo "Testing aggregation with Tokyo user:"
	@docker exec -it src-db-1 psql -U tokyo_user -d postgres -c "SELECT COUNT(*) as employee_count FROM employees;"

# ポリシー確認
show-policies:
	@echo "=== Current RLS Policies ==="
	@docker exec -it src-db-1 psql -U postgres -d postgres -c "SELECT schemaname, tablename, policyname, permissive, roles, cmd FROM pg_policies WHERE tablename IN ('employees', 'projects');"

# データ挿入テスト
test-insert:
	@echo "=== Testing data insertion ==="
	@echo "Inserting data as Praha user:"
	@docker exec -it src-db-1 psql -U praha_user -d postgres -c "INSERT INTO employees (tenant_id, name) VALUES (1, 'Test User Praha');"
	@echo "Checking inserted data:"
	@docker exec -it src-db-1 psql -U praha_user -d postgres -c "SELECT * FROM employees WHERE name = 'Test User Praha';"

# 開発用
dev-setup: clean-data up test-rls
	@echo "Development environment is ready!"

# すべてのテストを実行
test-all: test-rls test-queries show-policies
	@echo "All tests completed!"
