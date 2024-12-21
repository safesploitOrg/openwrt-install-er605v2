/**
 * Generate the passwords based on MAC address and username.
 */
function generatePasswords() {
    const macAddress = document.getElementById("inputMacAddress").value.trim().replaceAll("-", ":").toUpperCase();
    const username = document.getElementById("inputUsername").value.trim();
  
    // Generate Root password
    document.getElementById("rootPassword").textContent = md5(macAddress + username).substr(0, 16);
  
    // Generate CLI debug mode passwords for different versions
    document.getElementById("cliDebugPassword212").textContent = md5(macAddress + "admin").substr(0, 16);
    document.getElementById("cliDebugPassword222").textContent = md5(macAddress + "admin" + macAddress + "admin").substr(0, 16);
  }
  
  /**
   * Set the current year in the footer dynamically.
   */
  function setYear() {
    const currentYear = new Date().getFullYear();
    document.getElementById("currentYear").textContent = currentYear;
  }
  
  // Set the year when the page loads
  window.onload = setYear;
  