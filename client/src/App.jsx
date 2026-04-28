import "./App.css";
import EmployeeList from "./components/EmployeeList";
import Layout from "./components/Layout";
import SalaryInsights from "./components/SalaryInsights";

function App() {
  return (
    <Layout>
      <SalaryInsights />
      <EmployeeList />
    </Layout>
  );
}

export default App;