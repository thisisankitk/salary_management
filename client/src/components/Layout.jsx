function Layout({ children }) {
  return (
    <div className="app-shell">
      <header className="app-header">
        <div>
          <p className="eyebrow">HR Operations</p>
          <h1>Salary Management System</h1>
        </div>
        <span className="status-pill">Rails API + React UI</span>
      </header>

      <main className="app-main">{children}</main>
    </div>
  );
}

export default Layout;