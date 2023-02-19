const express = require("express");
const app = express();
const port = 3000;
const fs = require("fs");

app.use(express.json());

app.post("/postJob", (req, res) => {
  let jobs = JSON.parse(
    fs.readFileSync("./database/postedJobs.json").toString()
  );
  jobs.push(req.body);
  fs.writeFileSync("./database/postedJobs.json", JSON.stringify(jobs));
  res.send("Job posted");
});

app.post("/acceptJob", (req, res) => {
  let jobs = JSON.parse(
    fs.readFileSync("./database/postedJobs.json").toString()
  );
  const currentJob = jobs.find((job) => job.id === req.body.id);
  jobs = jobs.filter((job) => job.id !== req.body.id);
  fs.writeFileSync("./database/postedJobs.json", JSON.stringify(jobs));
  let acceptedJobs = JSON.parse(
    fs.readFileSync("./database/acceptedJobs.json").toString()
  );
  acceptedJobs.push(currentJob);
  fs.writeFileSync(
    "./database/acceptedJobs.json",
    JSON.stringify(acceptedJobs)
  );
  res.send("Job accepted");
});

app.post("/confirmJob", (req, res) => {
  let acceptedJobs = JSON.parse(
    fs.readFileSync("./database/acceptedJobs.json").toString()
  );
  acceptedJobs = acceptedJobs.filter((job) => job.id !== req.body.id);
  fs.writeFileSync(
    "./database/acceptedJobs.json",
    JSON.stringify(acceptedJobs)
  );

  // Send out smart contract

  res.send("Job confirmed");
});

app.get("/getJobs", (req, res) => {
  var jobs = JSON.parse(
    fs.readFileSync("./database/postedJobs.json").toString()
  );
  res.send(jobs);
});

app.listen(port, () => console.log(`app listening on port ${port}`));
