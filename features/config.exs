defmodule WhiteBreadConfig do
  use WhiteBread.SuiteConfiguration

  suite(
    name: "All",
    context: WhiteBreadContext,
    feature_paths: ["features/accounts/","features/parkingsearch/","features/payment/" ]
  )
end
