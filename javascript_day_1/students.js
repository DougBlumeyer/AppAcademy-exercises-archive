function Student(fname, lname) {
  this.fname = fname;
  this.lname = lname;
  this.courses = [];
}

Student.prototype.name = function () {
  console.log(this.fname + " " + this.lname);
}

Student.prototype.enroll = function (course) {
  var includes = false;
  for (var j = 0; j < this.courses.length; j++) {
    if (this.courses[j] === course) {
      includes = true;
    }
  };
  if (includes === false && !this.hasConflict(course)) {
    this.courses.push(course);
    course.students.push(this);
  }
}

Student.prototype.courseLoad = function () {
  var course_load_hash = {};
  for (var i = 0; i < this.courses.length; i++) {
    if (course_load_hash[this.courses[i].dept] === undefined) {
      course_load_hash[this.courses[i].dept] = this.courses[i].num_credits
    } else {
    course_load_hash[this.courses[i].dept] += this.courses[i].num_credits
    }
  };
  return course_load_hash;
}

Student.prototype.hasConflict = function (course) {
  for ( var i = 0; i < this.courses.length; i++ ){
    if (this.courses[i].conflictsWith(course)) {
      return true;
    }
  };
  return false;
}



//////////

function Course(name, dept, num_credits, days_of_week, time_block) {
  this.name = name;
  this.dept = dept;
  this.num_credits = num_credits;
  this.students = [];
  this.days_of_week = days_of_week;
  this.time_block = time_block;
}

Course.prototype.addStudent = function(student) {
  student.enroll(this);
}

Course.prototype.conflictsWith = function(other_course) {
  if (other_course.time_block != this.time_block) {
    return false;
  }
  for (var i = 0; i < this.days_of_week.length; i++) {
    for (var j = 0; j < other_course.days_of_week.length; j++) {
      if (this.days_of_week[i] === other_course.days_of_week[j]){
        return true;
      }
    };
  };
  return false;
}


//////



var a = new Student("Ozy", "Brennan");
var b = new Course("App Academy", "CS", 9999, ["m", "t", "w", "r", "f"], 8);
var c = new Course("Codecademy", "CS", 400, ["m", "w", "f"], 8);
var d = new Course("Basket weaving", "Art", 300, ["t"], 8);
// a.enroll(b);
a.enroll(c);
a.enroll(d);
