class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  REPORT_MODEL_NAME = ""
  REPORT_FIELDS = {
    name: "Name",
    issue: "Issue Date",
    finish: "Finish Date",
    completed: "Completed Date",
    notes: "Notes"
  }
end
