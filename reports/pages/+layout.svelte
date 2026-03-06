<script>
	import "@evidence-dev/tailwind/fonts.css";
	import "../app.css";
	import { EvidenceDefaultLayout } from "@evidence-dev/core-components";
	export let data;
</script>

<EvidenceDefaultLayout
	{data}
	hideSidebar="true"
	githubRepo="https://github.com/bchaoss/US-Tariff-What-Didnt-and-What-Did"
>
	<slot slot="content" />
</EvidenceDefaultLayout>
