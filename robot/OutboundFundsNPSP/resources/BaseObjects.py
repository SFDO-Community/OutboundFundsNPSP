from robot.libraries.BuiltIn import BuiltIn


class BaseOutboundFundsNPSPPage:
    @property
    def OutboundFundsNPSP(self):
        return self.builtin.get_library_instance("OutboundFundsNPSP")

    @property
    def pageobjects(self):
        return self.builtin.get_library_instance("cumulusci.robotframework.PageObjects")

    @property
    def builtin(self):
        return BuiltIn()

    @property
    def cumulusci(self):
        return self.builtin.get_library_instance("cumulusci.robotframework.CumulusCI")

    @property
    def salesforce(self):
        return self.builtin.get_library_instance("cumulusci.robotframework.Salesforce")

    @property
    def selenium(self):
        return self.builtin.get_library_instance("SeleniumLibrary")
