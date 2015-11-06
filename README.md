# coffeelint-no-shadow-requires

This is a simple AST linter for coffeelint that records the names of all the top-level variable assignments whose right-hand-side is a call to `require()`, then warns you if you shadow or redefine any of those variables later.

Install with npm, then add the following to your coffeelint.json to enable:

```
"no_shadow_requires": {
	"module": "coffeelint-no-shadow-requires"
}
```

## License

Copyright 2015 Ben Chociej

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
