collection @redacts
attributes :id, :code_name
if user_signed_in? && current_user.sweary
  node(:redact_array) { |redact| redact.redact_array_with_swears }
else
  node(:redact_array) { |redact| redact.redact_array }
end