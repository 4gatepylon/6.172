from opentuner import ConfigurationManipulator
from opentuner.search.manipulator import PowerOfTwoParameter

mdriver_manipulator = ConfigurationManipulator()

"""
See opentuner/search/manipulator.py for more parameter types,
like IntegerParameter, EnumParameter, etc.

TODO(project3): Implement the parameters of your allocator. Once
you have at least one other parameter, feel free to remove ALIGNMENT.
"""
mdriver_manipulator.add_parameter(PowerOfTwoParameter('ALIGNMENT', 8, 8))
mdriver_manipulator.add_parameter(PowerOfTwoParameter('BLOCK_SIZE', 2**5, 2**15))
