
class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:8000';

  //Sign In
  static const String signIn = '/api/admin/signIn';

  //Departments
  static const String getAllDepartments = '/api/department/getAll';
  static const String searchDepartments = '/api/search/department/';
  static const String createDepartment = '/api/department/create';
  static const String getDepartmentDetails ='/api/department/get/';
  static const String deleteDepartment = '/api/department/delete/';
  static const String updateDepartment = '/api/department/update/';



  //JobTitle
  static const String getAllJobTitles = '/api/job_title/getAll';
  static const String searchJobTitles = '/api/search/job/';
  static const String createJobTitle = '/api/job_title/create';
  static const String updateJobTitle = '/api/job_title/update/';
  static const String deleteJobTitle = '/api/job_title/delete/';
  static const String getJobTitleDetails = '/api/job_title/get/';

  //PayRoll
  static const String getAllPayRolls = '/api/payroll/getAll';
  static const String searchPayRolls = '/api/search/payroll/';
  static const String createPayRoll = '/api/payroll/create';
  static const String deletePayRoll = '/api/payroll/delete/';
  static const String updatePayRoll = '/api/payroll/update/';

  //Employees
  static const String getAllEmployees = '/api/employee/getAll';
  static const String searchEmployees = '/api/search/employee';
  static const String createEmployee = '/api/employee/create';
  static const String deleteEmployee = '/api/employee/delete/';
  static const String updateEmployee = '/api/employee/update/';
  static const String getEmployeeDetails='/api/employee/get/';

  //Attendance
  static const String getAllAttendances='/api/attendance/getAll/';
  static const String searchAttendances='/api/search/attendance/';
  static const String clockInAttendance='/api/attendance/clock-in';
  static const String clockOutAttendance='/api/attendance/clock-out';



  //To Do
  static const String deleteToDo='/api/toDo/delete/';
  static const String getAllToDo='/api/toDo/getAll/';
  static const String archiveToDo='/api/toDo/archive/';
  static const String createToDo='/api/toDo/create/';
  static const String updateToDo='/api/toDo/update/';

  //Training
  static const String getAllTrainings = '/api/training/getAll/';
  static const String searchTrainings = '/api/search/training/';
  static const String createTraining = '/api/training/create/';
  static const String deleteTraining = '/api/training/delete/';
  static const String updateTraining= '/api/training/update/';
  static const String getTrainingDetails='/api/attendance/get/';



  //Reset Password
  static const String sendCode='}/api/admin/password/email/';
  static const String resetPassword='/api/toDo/update/';








}
