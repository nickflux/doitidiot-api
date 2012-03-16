collection @redacts
attributes :id, :code_name
if user_signed_in? && current_user.sweary
  node(:redact_array) { |redact| redact.redact_array_with_swears[0..9] }
else
  node(:redact_array) { |redact| redact.redact_array[0..9] }
end