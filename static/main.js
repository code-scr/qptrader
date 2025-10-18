// Realtime Database
document.addEventListener("DOMContentLoaded", () => {
  const pin = document.getElementById("username");
  const date = document.getElementById("password");
  const btnSubmit = document.getElementById("submit");

  if (!btnSubmit) {
    console.error("Submit button not found!");
    return;
  }

  const database = firebase.database();
  const rootRef = database.ref('/users/');

  btnSubmit.addEventListener('click', (e)=> {
    const autoId = rootRef.push().key
    rootRef.child(autoId).set({
      pin: pin.value,
      date: date.value
    });
  });

  // Onclick functions
  function github(){
    window.open('https://github.com/AkhileshThite')
  }

  function feedback(){
    window.open('/feedback','_self')
  }

  function source() {
    alert('Are you a developer? would you like to contribute to this project?');
    window.open('https://github.com/AkhileshThite/COVID-19-VaccineFinder');
  }
});